import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/models/recipe.dart';

import '../widgets/touch_spin_form_field.dart';
import 'ingredient_list.dart';
import 'step_list.dart';

class RecipeForm extends StatefulWidget {
  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
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
            IngredientList(recipe.ingredients),
            StepList(recipe.steps),
            _buildSubmitButton(context)
          ],
        ));
  }

  Widget _buildRecipeNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Recipe name"),
      validator: (value) => value.isEmpty ? "Please enter a recipe name" : null,
      onSaved: (value) => recipe.name = value,
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
