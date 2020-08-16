import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes/TouchSpinFormField.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import 'model/Recipe.dart';

class AddRecipeScreen extends StatelessWidget {
  AddRecipeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: SizedBox.expand(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0), child: AddRecipeForm())),
    );
  }
}

class AddRecipeForm extends StatefulWidget {
  @override
  AddRecipeFormState createState() => AddRecipeFormState();
}

class AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  Recipe recipe = new Recipe(name: "", servings: 2, ingredients: [], steps: []);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildRecipeNameField(),
            _buildServingsField(),
            _buildIngredients(),
            _buildSubmitButton(context)
          ],
        ));
  }

  Widget _buildRecipeNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Recipe name"),
      autofocus: true,
      validator: (value) => value.isEmpty ? "Please enter a recipe name" : null,
      onSaved: (value) => recipe.name = value,
    );
  }

  Widget _buildIngredients() {
    return Padding(
        padding: EdgeInsets.only(top: 32, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildIngredientsHeader(),
            ...this.recipe.ingredients.map((i) => _buildIngredient(i)),
            _buildAddIngredientButton()
          ],
        ));
  }

  Widget _buildIngredientsHeader() {
    return Text('Ingredients', style: Theme.of(context).textTheme.headline5);
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
                this.recipe.ingredients.add(ingredient);
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
              this.recipe.ingredients.remove(ingredient);
            });
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget _buildServingsField() {
    return TouchSpinFormField(
      initialValue: 2,
      decoration: InputDecoration(labelText: "Servings"),
      onSaved: (value) => recipe.servings = value,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            print(recipe.toJson());
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          }
        },
        child: Text('Submit'),
      ))
    ]);
  }
}

class IngredientForm extends StatefulWidget {
  IngredientForm({
    this.ingredient,
    this.onSubmit,
  });

  final RecipeIngredient ingredient;
  final ValueChanged<RecipeIngredient> onSubmit;

  @override
  IngredientFormState createState() => IngredientFormState();
}

class IngredientFormState extends State<IngredientForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildIngredientNameField(),
            _buildIngredientAmountField(),
            _buildIngredientUnitField(),
            _buildSubmitButton()
          ],
        ));
  }

  Widget _buildIngredientNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name"),
      initialValue: widget.ingredient.ingredientName,
      autofocus: true,
      validator: (value) => value.isEmpty ? "Please enter a name" : null,
      onSaved: (value) => widget.ingredient.ingredientName = value,
    );
  }

  Widget _buildIngredientAmountField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Amount"),
        initialValue: widget.ingredient.amount?.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [ThousandsFormatter(allowFraction: true)],
        onSaved: (value) => widget.ingredient.amount = double.tryParse(value));
  }

  _buildIngredientUnitField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Unit"),
      initialValue: widget.ingredient.unit,
      onSaved: (value) => widget.ingredient.unit = value,
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
        padding: EdgeInsets.only(top: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          RaisedButton(
            child: Text('Add'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onSubmit(widget.ingredient);
                Navigator.of(context).pop();
              }
            },
          )
        ]));
  }
}
