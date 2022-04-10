import 'package:flutter/material.dart';

const _appTitle = "Hello World!";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Home Page"),
    );
  }
}

Widget _helloWorldWidget() {
  return const Text("Hello World!");
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_appTitle),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16.0), // spacer
            _helloWorldWidget(),
          ],
        ),
      ),
    );
  }
}
