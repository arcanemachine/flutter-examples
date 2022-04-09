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
  int _activeItemIndex = -1;

  // text field
  var _textValue = "";

  final _textFieldController = TextEditingController.fromValue(
    const TextEditingValue(text: ""),
  );
  late FocusNode _textFieldFocusNode;

  // lifecycle methods
  @override
  void initState() {
    super.initState();

    // controller
    _textFieldController.addListener(() {
      setState(() {
        _textValue = _textFieldController.text;
      });
    });

    // focus node
    _textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _todoList();
  }

  // widgets
  Widget _textSection() {
    return TextField( // text input
      controller: _textFieldController,
      focusNode: _textFieldFocusNode,
      // autofocus: true,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: "Enter a todo item",
      ),
      onSubmitted: (x) => _confirmButtonPressed(),
    );
  }

  void _setText(value) {
    setState(() {
      _textValue = value;
      _textFieldController.text = value;
    });
  }

  Widget _buttonSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            child: Text(_activeItemIndex != -1 ? "Update" : "Add"),
            onPressed:_textValue != "" ? _confirmButtonPressed : null,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: _activeItemIndex == -1 ? const Text('') : ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              child: const Text("Delete"),
              onPressed: () => _deleteButtonPressed(_activeItemIndex),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmButtonPressed() {
    _textFieldFocusNode.requestFocus();

    if (_activeItemIndex == -1) {
      // check for duplicates
      if (_todos.contains(_textValue)) {
        // show warning
        final snackBar = SnackBar(
          content: const Text("Duplicate items not allowed"),
          action: SnackBarAction(
            label: "OK",
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      } else {
        // add item
        setState(() {
          _todos.add(_textValue);
        });

        // reset the text field
        _setText("");
      }

    } else {
      // update item
      setState(() {
        _todos[_activeItemIndex] = _textValue;
        _activeItemIndex = -1;
      });

      // reset the text field
      _setText("");
    }
  }

  void _editButtonPressed(itemIndex) {
    // if no item is active, then enable the current one.
    // otherwise, set active to null
    if (_activeItemIndex != itemIndex) {
      setState(() {
        _activeItemIndex = itemIndex;
      });
      _setText(_todos[itemIndex]);
      _textFieldFocusNode.requestFocus();
    } else {
      setState(() {
        _activeItemIndex = -1;
      });
      _setText("");
    }
  }

  void _deleteButtonPressed(itemIndex) {
    setState(() {
      _todos.removeAt(itemIndex);
      _activeItemIndex = -1;
    });
    _setText("");

    // show message
    final snackBar = SnackBar(
      content: const Text("Item removed"),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _todoListItems() {
    if (_todos.isEmpty) {
      // if the list is empty, display a message
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text('You have no todo items.'),
        ),
      );
    } else {
      // display non-empty list
      return Flexible(
        child: ListView.builder( // item list
          itemCount: _todos.length,
          itemBuilder: (context, i) {
            return Row(
              children: [
                Flexible(
                  child: Container(
                    child: _todoListItem(i, _todos[i]),
                  ),
                ),
              ],
            );
          }
        ),
      );
    }
  }

  Widget _todoListItem(int itemIndex, var itemText) {
    return Padding(
      padding: const EdgeInsets.all(12),
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
        ? const Icon(
            Icons.cancel,
            semanticLabel: "Cancel",
          )
        : const Icon(
            Icons.edit,
            semanticLabel: "Edit",
      )),
      onPressed: () => _editButtonPressed(itemIndex),
    );
  }

  Widget _todoList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _textSection(),
          _buttonSection(),
          _todoListItems(),
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
          title: const Text('Todo List'),
          backgroundColor: Colors.blue,
        ),
        body: const TodoForm(),
      ),
    );
  }
}