import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/widgets/draggable_list.dart';

import 'ingredient_form.dart';

class IngredientList extends StatefulWidget {
  final List<RecipeIngredient> ingredients;

  IngredientList(this.ingredients);

  @override
  State<StatefulWidget> createState() => IngredientListState();
}

class IngredientListState extends State<IngredientList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 32, bottom: 32),
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
      child: Text(
        ingredient.toString(),
        style: Theme.of(context).textTheme.subtitle1,
      ),
      onTap: () => showDialog(
        context: context,
        child: _buildEditIngredientDialog(ingredient),
      ),
    );
  }

  Widget _buildAddIngredientButton() {
    return OutlineButton.icon(
        icon: Icon(Icons.add),
        label: Text('Add Ingredient'),
        onPressed: () => showDialog(
            context: context,
            builder: (context) => _buildAddIngredientDialog()));
  }

  Widget _buildAddIngredientDialog() {
    return AlertDialog(
      title: Text('Add ingredient'),
      content: IngredientForm(
          ingredient: RecipeIngredient(),
          onSubmit: (ingredient) => setState(() {
                widget.ingredients.add(ingredient);
              })),
    );
  }

  Widget _buildEditIngredientDialog(RecipeIngredient ingredient) {
    return AlertDialog(
      title: Text('Edit ingredient'),
      content: IngredientForm(
          ingredient: ingredient, onSubmit: (ingredient) => setState(() {})),
    );
  }
}
