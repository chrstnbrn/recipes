import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/recipe_form/recipe_form.dart';
import 'package:recipes/store/recipe_repository.dart';

class AddRecipeScreen extends StatelessWidget {
  AddRecipeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<RecipeRepository>(context);
    final formKey = GlobalKey<RecipeFormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              var recipe = formKey.currentState.submit();
              if (recipe != null) {
                repository.addRecipe(recipe);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: RecipeForm(
            key: formKey,
            recipe: Recipe(
              id: null,
              name: '',
              servings: 2,
              ingredients: [],
              steps: [],
            ),
          ),
        ),
      ),
    );
  }
}
