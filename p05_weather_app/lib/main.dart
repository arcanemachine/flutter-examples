import 'dart:io';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import 'package:p05_weather_app/examples.dart';
// import 'package:p05_weather_app/models.dart';


Future<Database> databaseGetOrCreate() async {
  // platform-specific boilerplate
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit(); // initialize FFI
  }
  databaseFactory = databaseFactoryFfi;

  // avoid errors caused by flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();

  // get or create database
  final db = openDatabase(
    join(await getDatabasesPath(), 'db.sqlite3'),
    onCreate: (database, version) {
      return database.execute(
        'CREATE TABLE cities('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'city_id TEXT'
        ')',
      );
    },
    version: 1,
  );

  // if (kDebugMode) {
  //   runExamples(db);
  // }

  return db;
}

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appTitle = "Flutter Weather";
  late Database db;

  @override
  void initState() {
    super.initState();

    asyncInitDb().then((response) {
      setState(() {
        db = response;
      });
    });
  }

  asyncInitDb<Database>() async {
    return databaseGetOrCreate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(
        title: _appTitle,
        db: db,
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
    required this.title,
    required this.db,
  }) : super(key: key);

  final String title;
  final Database db;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("Database is ${widget.db.isOpen ? "open" : "closed"}!"),
      ),
    );
  }
}