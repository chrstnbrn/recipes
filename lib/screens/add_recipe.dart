import 'package:flutter/material.dart';
import 'package:recipes/recipe_form/recipe_form.dart';

class AddRecipeScreen extends StatelessWidget {
  AddRecipeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: SizedBox.expand(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0), child: RecipeForm())),
    );
  }
}
