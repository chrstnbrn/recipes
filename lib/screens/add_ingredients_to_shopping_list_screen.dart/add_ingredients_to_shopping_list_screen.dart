import 'package:flutter/material.dart';

import '../../models/recipe.dart';

class AddIngredientsToShoppingListScreen extends StatelessWidget {
  const AddIngredientsToShoppingListScreen({
    Key key,
    @required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to shopping list'),
      ),
      body: ListView(
        children: recipe.ingredients
            .map(
              (i) => CheckboxListTile(
                  title: Text(i.ingredientName),
                  value: false,
                  onChanged: (checked) {}),
            )
            .toList(),
      ),
    );
  }
}
