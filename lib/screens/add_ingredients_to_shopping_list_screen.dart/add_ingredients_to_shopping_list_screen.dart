import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes/models/shopping_list_item.dart';
import 'package:recipes/models/user.dart';
import 'package:recipes/store/shopping_list_repository.dart';

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
    this.ingredients = Map.fromEntries(
      ingredients.map((i) => MapEntry(i, true)),
    );
  }

  Map<RecipeIngredient, bool> ingredients;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to shopping list'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _addToShoppingList(context),
          ),
        ],
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
      title: Text(entry.key.toString()),
      value: entry.value,
      onChanged: (checked) => _toggleIngredient(entry.key),
    );
  }

  void _toggleIngredient(RecipeIngredient ingredient) {
    setState(() => ingredients.update(ingredient, (isChecked) => !isChecked));
  }

  void _addToShoppingList(BuildContext context) {
    var repository = Provider.of<ShoppingListRepository>(
      context,
      listen: false,
    );
    var user = Provider.of<User>(
      context,
      listen: false,
    );

    var shoppingListItems = ingredients.entries
        .where((entry) => entry.value)
        .map((entry) => ShoppingListItem.fromIngredient(entry.key))
        .toList();

    repository.addItems(shoppingListItems, user.crewId);

    Navigator.of(context).pop();
  }
}
