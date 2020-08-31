import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../routes.dart';
import '../store/recipe_repository.dart';
import '../widgets/checkable_text.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({Key key, this.recipeId}) : super(key: key);

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<RecipeRepository>(context);

    return StreamBuilder<Recipe>(
        stream: repository.recipe(recipeId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildContent(snapshot.data, context, repository);
          }
          return const CircularProgressIndicator();
        });
  }

  Widget _buildContent(
      Recipe recipe, BuildContext context, RecipeRepository repository) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildRecipeDetail(recipe),
      ),
    );
  }

  Widget _buildRecipeDetail(Recipe recipe) {
    return Column(children: <Widget>[
      Flexible(child: _buildRecipeList(recipe)),
    ]);
  }

  Widget _buildRecipeList(Recipe recipe) {
    var itemsToDisplay = <RecipeDetailListItem>[
      ...recipe.ingredients,
      ...recipe.steps,
    ];

    return ListView.builder(
        itemCount: itemsToDisplay.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          final item = itemsToDisplay[i];
          if (item is RecipeIngredient) {
            return Text(item.toString());
          } else if (item is RecipeStep) {
            return Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: CheckableText(text: item.description));
          } else {
            return const Text('');
          }
        });
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
