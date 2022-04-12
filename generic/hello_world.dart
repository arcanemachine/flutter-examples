import 'package:flutter/material.dart';

Widget _helloWorld() {
  return const Text("Hello World!");
}

// widget
class HelloState extends StatefulWidget {
  const HelloState({Key? key}) : super(key: key);

  @override
  State<HelloState> createState() => _HelloState();
}

class _HelloState extends State<HelloState> {
  int counter = 0;

  void _counterIncrement() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(counter.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _counterIncrement,
        ),
      ],
    );
  }
}