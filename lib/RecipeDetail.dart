import 'package:flutter/material.dart';
import 'package:recipes/CheckableText.dart';

import 'model/Recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  RecipeDetailScreen({Key key, this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe: ${recipe.name}')),
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
            return Text(getIngredientText(item));
          } else if (item is RecipeStep) {
            return Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: CheckableText(text: item.description));
          } else {
            return Text("");
          }
        });
  }

  String getIngredientText(RecipeIngredient ingredient) {
    var result = "";
    if (ingredient.amount != null) result += "${ingredient.amount} ";
    if (ingredient.unit != null) result += "${ingredient.unit} ";
    result += ingredient.ingredientName;
    return result;
  }
}
