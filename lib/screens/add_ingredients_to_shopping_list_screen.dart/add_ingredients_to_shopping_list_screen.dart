import 'package:flutter/material.dart';

import '../../models/recipe.dart';
import '../../models/recipe_ingredient.dart';

class AddIngredientsToShoppingListScreen extends StatefulWidget {
  const AddIngredientsToShoppingListScreen({
    Key key,
    @required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  _AddIngredientsToShoppingListScreenState createState() =>
      _AddIngredientsToShoppingListScreenState(recipe.ingredients);
}

class _AddIngredientsToShoppingListScreenState
    extends State<AddIngredientsToShoppingListScreen> {
  _AddIngredientsToShoppingListScreenState(List<RecipeIngredient> ingredients) {
    this.ingredients =
        Map.fromEntries(ingredients.map((i) => MapEntry(i, true)));
  }

  Map<RecipeIngredient, bool> ingredients;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to shopping list'),
      ),
      body: ListView(
        children: ingredients.entries.map(_buildCheckboxListTile).toList(),
      ),
    );
  }

  CheckboxListTile _buildCheckboxListTile(
    MapEntry<RecipeIngredient, bool> entry,
  ) {
    return CheckboxListTile(
      title: Text(entry.key.ingredientName),
      value: entry.value,
      onChanged: (checked) => _toggleIngredient(entry.key),
    );
  }

  void _toggleIngredient(RecipeIngredient ingredient) {
    setState(() => ingredients.update(ingredient, (isChecked) => !isChecked));
  }
}
