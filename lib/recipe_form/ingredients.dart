import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/recipe_ingredient.dart';

class Ingredients extends StatelessWidget {
  const Ingredients({
    Key key,
    @required this.ingredients,
  }) : super(key: key);

  final List<RecipeIngredient> ingredients;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Ingredients',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: ingredients.length,
            itemBuilder: (context, index) => Text(
              ingredients[index].toString(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
