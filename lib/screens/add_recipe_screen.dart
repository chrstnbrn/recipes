import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../models/user.dart';
import '../recipe_form/recipe_form.dart';
import '../store/recipe_repository.dart';
import '../widgets/screen_body.dart';

class AddRecipeScreen extends StatelessWidget {
  const AddRecipeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<RecipeRepository>(context);
    var user = Provider.of<User>(context);

    final formKey = GlobalKey<RecipeFormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
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
                repository.addRecipe(recipe, user.crewId);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ScreenBody(
        child: RecipeForm(
          key: formKey,
          recipe: Recipe(
            id: null,
            name: '',
            servings: 2,
            steps: [],
          ),
        ),
      ),
    );
  }
}
