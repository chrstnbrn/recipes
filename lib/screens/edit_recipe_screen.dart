import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/recipe_form/recipe_form.dart';
import 'package:recipes/store/recipe_repository.dart';

class EditRecipeScreen extends StatelessWidget {
  final String recipeId;

  EditRecipeScreen({Key key, @required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<RecipeRepository>(context);

    return FutureBuilder(
      future: repository.recipe(recipeId).first,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        return _buildContent(context, repository, snapshot.data);
      },
    );
  }

  Scaffold _buildContent(
    BuildContext context,
    RecipeRepository repository,
    Recipe recipe,
  ) {
    final formKey = GlobalKey<RecipeFormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Recipe'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              var recipe = formKey.currentState.submit();
              if (recipe != null) {
                repository.updateRecipe(recipe);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: RecipeForm(key: formKey, recipe: recipe),
        ),
      ),
    );
  }
}
