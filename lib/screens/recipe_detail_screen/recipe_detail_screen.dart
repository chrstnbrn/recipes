import 'package:flutter/material.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recipes/screens/add_ingredients_to_shopping_list_screen.dart/add_ingredients_to_shopping_list_screen.dart';

import '../../models/recipe.dart';
import '../../models/user.dart';
import '../../routes.dart';
import '../../store/recipe_detail_service.dart';
import '../../store/recipe_repository.dart';
import '../../widgets/screen_body.dart';
import 'recipe_detail_ingredients.dart';
import 'recipe_detail_steps.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({Key key, this.recipeId}) : super(key: key);

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<RecipeRepository>(context);
    var user = Provider.of<User>(context);
    var service = RecipeDetailService(
      recipeId: recipeId,
      crewId: user?.crewId,
      repository: repository,
    );

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
                icon: const Icon(Icons.shopping_basket),
                onPressed: () => _onAddToShoppingList(context, recipe),
              ),
              _buildPopupMenuButton(context, recipe, repository, user),
            ],
          ),
          body: ScreenBody(
            child: _buildRecipeDetail(
              recipe,
              (servings) => service.changeServings(servings),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(
                Routes.recipeInstruction,
                arguments: {'recipe': recipe},
              );
            },
            child: const Icon(Icons.fastfood),
          ),
        );
      },
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(
    BuildContext context,
    Recipe recipe,
    RecipeRepository repository,
    User user,
  ) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 'Edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'Delete',
            child: Text('Delete'),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 'Edit':
            _onEdit(context, recipe);
            break;
          case 'Delete':
            _onDelete(context, repository, recipe, user);
            break;
        }
      },
    );
  }

  void _onAddToShoppingList(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (c) => AddIngredientsToShoppingListScreen(recipe: recipe),
        fullscreenDialog: true,
      ),
    );
  }

  void _onEdit(BuildContext context, Recipe recipe) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(
      Routes.editRecipe,
      arguments: {'recipeId': recipe.id},
    );
  }

  void _onDelete(
    BuildContext context,
    RecipeRepository repository,
    Recipe recipe,
    User user,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => _buildConfirmDeletionDialog(
        onConfirm: () async {
          await repository.deleteRecipe(recipe.id, user.crewId);
          Navigator.of(context)..pop()..pop();
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
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
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
