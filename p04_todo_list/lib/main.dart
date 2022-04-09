// import 'package:flutter/foundation.dart';
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
  final _todos = [];
  // ignore: unused_field, prefer_final_fields, avoid_init_to_null
  int _activeItemIndex = -1;

  // text field
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

  void _textSet(value) {
    setState(() {
      _textValue = value;
      _controller.text = value;
    });
  }

  // add/update button
  void _confirmButtonPressed() {
    if (_activeItemIndex == -1) {
      setState(() {
        _todos.add(_textValue);
      });
      _textSet("");
    } else {
      setState(() {
        _todos[_activeItemIndex] = _textValue;
        _activeItemIndex = -1;
      });

    }
  }

  // edit button
  void _editButtonPressed(itemIndex) {
    // if no item is active, then enable the current one.
    // otherwise, set active to null
    if (_activeItemIndex != itemIndex) {
      setState(() {
        _activeItemIndex = itemIndex;
      });
      _textSet(_todos[itemIndex]);
      // todo: focus the text input
    } else {
      setState(() {
        _activeItemIndex = -1;
      });
      _textSet("");
    }
  }

  Widget _todoList() {
    return Flexible(
      child: ListView.builder( // item list
        itemCount: _todos.length,
        itemBuilder: (context, i) {
          return ListTile(
            title: Row(
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0),
                    ),
                    child: _todoListItem(i, '- ${_todos[i]}'),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _todoListItem(int itemIndex, var itemText) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(itemText),
          _editButton(itemIndex),
        ],
      ),
    );
  }

  Widget _editButton(int itemIndex) {
    return IconButton(
      icon: (_activeItemIndex == itemIndex
        ? const Icon(Icons.cancel)
        : const Icon(Icons.edit)),
      onPressed: () => _editButtonPressed(itemIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField( // text input
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: "Enter a todo item",
            ),
            // onSubmitted: (value) => _confirmButtonPressed,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              // todo: make button bigger
              // style: const ButtonStyle(
              //   padding: EdgeInsets.all(4),
              // ),
              onPressed:_textValue != "" ? _confirmButtonPressed : null,
              child: Text(_activeItemIndex != -1 ? "Update" : "Add"),
            ),
          ),
          _todoList(),
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