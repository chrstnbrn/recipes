import 'package:flutter/widgets.dart';

import '../../models/recipe_ingredient.dart';

class RecipeDetailIngredients extends StatelessWidget {
  const RecipeDetailIngredients({
    Key key,
    @required this.ingredients,
  }) : super(key: key);

  final List<RecipeIngredient> ingredients;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: ingredients.length,
      itemBuilder: (context, index) => Text(ingredients[index].toString()),
    );
  }
}
