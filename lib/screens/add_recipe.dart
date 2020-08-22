import 'package:flutter/material.dart';
import 'package:recipes/recipe_form/recipe_form.dart';
import 'package:recipes/store/recipe_repository.dart';

class AddRecipeScreen extends StatelessWidget {
  final RecipeRepository repository;

  AddRecipeScreen({Key key, this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: SizedBox.expand(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: RecipeForm(onSubmit: (recipe) {
                repository.addRecipe(recipe);
                Navigator.of(context).pop();
              }))),
    );
  }
}
