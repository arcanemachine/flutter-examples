import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// text input
class TodoForm extends StatefulWidget {
  const TodoForm({Key? key}) : super(key: key);

  @override
  _TodoFormState createState() => _TodoFormState();


}

class _TodoFormState extends State<TodoForm> {
  // todos
  final _todos = ["Get cat food", "Do laundry"];

  // text input - setup controller
  var _textValue = "";

  final _controller = TextEditingController.fromValue(
    const TextEditingValue(text: ""),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _textValue = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // add item
  void _handleClick() {
    setState(() {
      _todos.add(_textValue);
      _textValue = "";
      _controller.text = "";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: "Enter a todo item",
            ),
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: _textValue != "" ? _handleClick : null,
              child: const Text('Add'),
            ),
          ),
          Flexible(
            child: Text('Item count: ${_todos.length}'),
          ),
          Flexible(
            child: Text('Todo text: ${_textValue}'),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(_todos[i]),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

// main widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello world!",
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Bar'),
          backgroundColor: Colors.green,
        ),
        body: const TodoForm(),
      ),
    );
  }
}