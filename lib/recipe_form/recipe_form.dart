import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/widgets/touch_spin_form_field.dart';

import 'ingredient_list.dart';
import 'step_list.dart';

class RecipeForm extends StatefulWidget {
  final Recipe recipe;
  final ValueChanged<Recipe> onSubmit;

  RecipeForm({@required this.recipe, @required this.onSubmit});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildRecipeNameField(),
            _buildServingsField(),
            IngredientList(widget.recipe.ingredients),
            StepList(widget.recipe.steps),
            _buildSubmitButton(context)
          ],
        ));
  }

  Widget _buildRecipeNameField() {
    return TextFormField(
      initialValue: widget.recipe.name,
      decoration: InputDecoration(labelText: "Recipe name"),
      validator: (value) => value.isEmpty ? "Please enter a recipe name" : null,
      onSaved: (value) => widget.recipe.name = value,
    );
  }

  Widget _buildServingsField() {
    return TouchSpinFormField(
      initialValue: widget.recipe.servings,
      decoration: InputDecoration(labelText: "Servings"),
      onSaved: (value) => widget.recipe.servings = value,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            print(widget.recipe.toJson());
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
            widget.onSubmit(widget.recipe);
          }
        },
        child: Text('Submit'),
      ))
    ]);
  }
}
