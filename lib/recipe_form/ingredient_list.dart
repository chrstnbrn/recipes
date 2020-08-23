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
            _buildAddIngredientButton()
          ],
        ));
  }

  Widget _buildIngredientsHeader() {
    return Text('Ingredients', style: Theme.of(context).textTheme.headline5);
  }

  Widget _buildIngredientList() {
    return DraggableList(
      items: widget.ingredients,
      itemBuilder: (context, ingredient) {
        return _buildIngredient(ingredient);
      },
    );
  }

  Widget _buildIngredient(RecipeIngredient ingredient) {
    return ListTile(
      title: Text(ingredient.toString()),
      trailing: new Row(mainAxisSize: MainAxisSize.min, children: [
        new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => _buildEditIngredientDialog(ingredient))),
        new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => _buildDeleteIngredientDialog(ingredient)))
      ]),
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
          ingredient: new RecipeIngredient(),
          onSubmit: (ingredient) => setState(() {
                this.widget.ingredients.add(ingredient);
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

  Widget _buildDeleteIngredientDialog(RecipeIngredient ingredient) {
    return AlertDialog(
      title: Text("Delete ${ingredient.ingredientName}?"),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          textColor: Theme.of(context).hintColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        RaisedButton(
          child: Text('Delete'),
          color: Theme.of(context).errorColor,
          onPressed: () {
            setState(() {
              this.widget.ingredients.remove(ingredient);
            });
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
