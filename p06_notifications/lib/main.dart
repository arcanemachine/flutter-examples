import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // get device token (this only needs to run once to get the device's token)
  // print("Token: ${await FirebaseMessaging.instance.getToken()}");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // main tutorial stuff
  // https://firebase.flutter.dev/docs/messaging/notifications
  Future<void> setupInteractedMessage() async {
    // get any messages which caused the application to open from a
    // terminated state
    RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

    // use custom data properties (e.g. 'chat') to allow for specific actions
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

  }

  void _handleMessage(RemoteMessage message) {
    late String snackbarMessage;

    if (message.data['type'] == 'chat') {
      snackbarMessage = "Firebase data type 'chat' received. Let's talk!";
    } else {
      print("WTF");
      snackbarMessage =
        "We received a '${message.data['type']}' type message. Cool!";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(snackbarMessage)),
    );
  }


  // other tutorial stuff
  Future<void> otherTutorialStuff() async {
    // create android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'This channel is used for important notifications.', // description
      description: 'High Importance Notifications', // title
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // icon: Icons.Icon(android.smallIcon),
                // other properties...
              ),
            ));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    setupInteractedMessage();
    otherTutorialStuff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You pushed that darn button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
