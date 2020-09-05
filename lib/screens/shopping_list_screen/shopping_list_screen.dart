import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: const Scrollbar(child: Text('Shopping List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
