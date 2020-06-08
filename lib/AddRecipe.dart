import 'package:flutter/material.dart';

class AddRecipeScreen extends StatelessWidget {
  AddRecipeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: Padding(
          padding: EdgeInsets.all(16.0), child: _buildRecipeDetail()),
    );
  }

  Widget _buildRecipeDetail() {
    return Container(
        child: Column(children: <Widget>[]));
  }

}
