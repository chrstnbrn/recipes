import 'package:flutter/material.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/recipe.dart';
import '../../routes.dart';
import '../../store/recipe_detail_service.dart';
import '../../store/recipe_repository.dart';
import 'recipe_detail_ingredients.dart';
import 'recipe_detail_steps.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({Key key, this.recipeId}) : super(key: key);

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<RecipeRepository>(context);
    var service = RecipeDetailService(recipeId, repository);

    return StreamBuilder<Recipe>(
      stream: service.recipe$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        var recipe = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(recipe.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.editRecipe,
                  arguments: {'recipeId': recipe.id},
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => _buildConfirmDeletionDialog(
                    onConfirm: () async {
                      await repository.deleteRecipe(recipe.id);
                      Navigator.of(context)..pop()..pop();
                    },
                    onCancel: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildRecipeDetail(
                recipe,
                (servings) => service.changeServings(servings),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeDetail(
    Recipe recipe,
    void Function(int) onChangeServings,
  ) {
    return Column(children: [
      _buildServingsField(recipe, onChangeServings),
      RecipeDetailIngredients(ingredients: recipe.ingredients),
      RecipeDetailSteps(steps: recipe.steps),
    ]);
  }

  Widget _buildServingsField(
    Recipe recipe,
    void Function(int) onChangeServings,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TouchSpin(
          value: recipe.servings,
          displayFormat: NumberFormat(),
          onChanged: (value) {
            onChangeServings(value.toInt());
          },
        )
      ],
    );
  }

  Widget _buildConfirmDeletionDialog({
    @required void Function() onConfirm,
    @required void Function() onCancel,
  }) {
    return AlertDialog(
      title: const Text('Delete recipe?'),
      actions: [
        FlatButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        FlatButton(
          onPressed: onConfirm,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
