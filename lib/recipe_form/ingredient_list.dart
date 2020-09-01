import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/recipe_ingredient.dart';
import '../widgets/draggable_list.dart';
import 'ingredient_form.dart';

class IngredientList extends StatefulWidget {
  const IngredientList({
    Key key,
    @required this.ingredients,
  }) : super(key: key);

  final List<RecipeIngredient> ingredients;

  @override
  State<StatefulWidget> createState() => IngredientListState();
}

class IngredientListState extends State<IngredientList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildIngredientsHeader(),
            _buildIngredientList(),
            _buildAddIngredientButton(),
          ],
        ));
  }

  Widget _buildIngredientsHeader() {
    return Text('Ingredients', style: Theme.of(context).textTheme.headline5);
  }

  Widget _buildIngredientList() {
    return DraggableList(
      items: widget.ingredients,
      itemBuilder: _buildIngredient,
      swipeToDelete: true,
      onDelete: _showUndoDeleteIngredientSnackBar,
    );
  }

  void _showUndoDeleteIngredientSnackBar(
    RecipeIngredient ingredient,
    int index,
  ) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ingredient "${ingredient.toString()}"'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() => widget.ingredients.insert(index, ingredient));
          },
        ),
      ),
    );
  }

  Widget _buildIngredient(BuildContext context, RecipeIngredient ingredient) {
    return InkWell(
      onTap: () => showDialog<void>(
        context: context,
        child: _buildEditIngredientDialog(ingredient),
      ),
      child: Text(
        ingredient.toString(),
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }

  Widget _buildAddIngredientButton() {
    return OutlineButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add Ingredient'),
        onPressed: () => showDialog<void>(
            context: context,
            builder: (context) => _buildAddIngredientDialog()));
  }

  Widget _buildAddIngredientDialog() {
    return AlertDialog(
      title: const Text('Add ingredient'),
      content: IngredientForm(
          ingredient: RecipeIngredient(ingredientName: ''),
          onSubmit: (ingredient) => setState(() {
                widget.ingredients.add(ingredient);
              })),
    );
  }

  Widget _buildEditIngredientDialog(RecipeIngredient ingredient) {
    return AlertDialog(
      title: const Text('Edit ingredient'),
      content: IngredientForm(
          ingredient: ingredient, onSubmit: (ingredient) => setState(() {})),
    );
  }
}
