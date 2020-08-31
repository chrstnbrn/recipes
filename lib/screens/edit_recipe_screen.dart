import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../recipe_form/recipe_form.dart';
import '../store/recipe_repository.dart';

class EditRecipeScreen extends StatelessWidget {
  const EditRecipeScreen({Key key, @required this.recipeId}) : super(key: key);

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<RecipeRepository>(context);

    return FutureBuilder<Recipe>(
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
        title: const Text('Edit Recipe'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
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
          padding: const EdgeInsets.all(16.0),
          child: RecipeForm(key: formKey, recipe: recipe),
        ),
      ),
    );
  }
}
