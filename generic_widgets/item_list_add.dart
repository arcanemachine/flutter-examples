import 'package:flutter/material.dart';

const _appTitle = "Hello World!";

class ListAdder extends StatefulWidget {
  const ListAdder({Key? key}) : super(key: key);

  @override
  State<ListAdder> createState() => _ListAdderState();
}

class _ListAdderState extends State<ListAdder> {
  final _formKey = GlobalKey<FormState>();

  final _items = [];
  var _textValue = "stuff";

  // text field controller
  final _textFieldController = TextEditingController.fromValue(
    const TextEditingValue(text: ""),
  );

  @override
  void initState() {
    super.initState();

    // controller
    _textFieldController.addListener(() {
      setState(() {
        _textValue = _textFieldController.text;
      });
    });
  }

  @override
  void dispose() {
    _textFieldController.dispose();

    super.dispose();
  }

  Widget _itemForm() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: TextFormField(
              controller: _textFieldController,
              // focusNode: _textFieldFocusNode,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(4),
                hintText: "Enter some words to add.",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter some text.";
                }
                return null;
              },
              onFieldSubmitted: (x) => _itemAdd,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _textValue == "" ? null : () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Item added")),
                );
              }
              _itemAdd();
            },
            child: const Text("Add Item"),
          ),
        ],
      ),
    );
  }

  Widget _itemList() {
    return Flexible(child: ListView.builder(
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int i) {
        return Center(
          child: Text(_items[i]),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _itemForm(),
          _itemList(),
        ],
      ),
    );
  }

  void _itemAdd() {
    setState(() {
      _items.add(_textValue);
    });
  }
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
      body: const Center(
        child: ListAdder(),
      ),
    );
  }
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

void main() {
  runApp(const MyApp());
}