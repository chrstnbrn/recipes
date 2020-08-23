import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes/routes.dart';
import 'package:recipes/store/recipe_repository.dart';
import 'package:recipes/widgets/checkable_text.dart';

import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  RecipeDetailScreen({Key key, this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<RecipeRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, Routes.editRecipe,
                arguments: {"recipe": recipe}),
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) => _buildConfirmDeletionDialog(
                      onConfirm: () async {
                        await repository.deleteRecipe(recipe.id);
                        Navigator.of(context)..pop()..pop();
                      },
                      onCancel: () => Navigator.of(context).pop(),
                    ),
                  ))
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0), child: _buildRecipeDetail(recipe)),
    );
  }

  Widget _buildRecipeDetail(Recipe recipe) {
    return Container(
        child: Column(children: <Widget>[
      Flexible(child: _buildRecipeList(recipe)),
    ]));
  }

  Widget _buildRecipeList(Recipe recipe) {
    var itemsToDisplay = List<RecipeDetailListItem>();
    itemsToDisplay.addAll(recipe.ingredients);
    itemsToDisplay.addAll(recipe.steps);

    return ListView.builder(
        itemCount: itemsToDisplay.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          final item = itemsToDisplay[i];
          if (item is RecipeIngredient) {
            return Text(item.toString());
          } else if (item is RecipeStep) {
            return Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: CheckableText(text: item.description));
          } else {
            return Text("");
          }
        });
  }

  Widget _buildConfirmDeletionDialog(
      {@required Function onConfirm, @required Function onCancel}) {
    return AlertDialog(
      title: Text("Delete recipe?"),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: onCancel,
        ),
        FlatButton(
          child: Text('Delete'),
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
