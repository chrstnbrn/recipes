import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/recipe_form/recipe_form.dart';
import 'package:recipes/store/recipe_repository.dart';

class EditRecipeScreen extends StatelessWidget {
  final Recipe recipe;

  EditRecipeScreen({Key key, @required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<RecipeRepository>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Edit Recipe')),
      body: SizedBox.expand(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: RecipeForm(
                  recipe: recipe,
                  onSubmit: (recipe) {
                    repository.addRecipe(recipe);
                    Navigator.of(context).pop();
                  }))),
    );
  }
}
