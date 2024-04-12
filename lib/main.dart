import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter List App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'List App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ListItem {
  String id;
  String name;
  String group;

  ListItem(this.id, this.name, this.group);
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ListItem> _items = [];
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _groupController = TextEditingController();

  void _addItem() {
    if (_idController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _groupController.text.isEmpty) {
      return;
    }
    setState(() {
      _items.add(ListItem(
        _idController.text,
        _nameController.text,
        _groupController.text,
      ));
    });
  }

  void _updateItem(int index) {
    setState(() {
      _items[index] = ListItem(
        _idController.text,
        _nameController.text,
        _groupController.text,
      );
    });

    _idController.clear;
    _nameController.clear;
    _groupController.clear;

    Navigator.of(context).pop();
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _showForm(BuildContext ctx,
      {required ListItem? item, required int index}) {
    if (item != null) {
      _idController.text = item.id;
      _nameController.text = item.id;
      _groupController.text = item.id;
    }

    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID'),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _groupController,
                decoration: const InputDecoration(labelText: 'Group'),
              ),
              ElevatedButton(
                child: Text(item == null ? 'Add' : 'Update'),
                onPressed: () => item == null ? _addItem() : _updateItem(index),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple List App'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index].name),
            subtitle:
                Text('ID${_items[index].id}, Group: ${_items[index].group}'),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        _showForm(context, item: _items[index], index: index),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('Do you want to delete the item?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              _deleteItem(index);
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(context, index: _items.length, item: null),
      ),
    );
  }
}
