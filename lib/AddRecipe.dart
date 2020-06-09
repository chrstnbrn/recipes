import 'package:flutter/material.dart';
import 'package:recipes/TouchSpinFormField.dart';

import 'model/Recipe.dart';

class AddRecipeScreen extends StatelessWidget {
  AddRecipeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: Padding(padding: EdgeInsets.all(16.0), child: AddRecipeForm()),
    );
  }
}

class AddRecipeForm extends StatefulWidget {
  @override
  AddRecipeFormState createState() => AddRecipeFormState();
}

class AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  final Recipe recipe = new Recipe(servings: 2);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildRecipeNameField(),
            _buildServingsField(),
            _buildRaisedButton(context)
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

  Widget _buildServingsField() {
    return TouchSpinFormField(
      initialValue: 2,
      decoration: InputDecoration(labelText: "Servings"),
      onSaved: (value) => recipe.servings = value,
    );
  }

  RaisedButton _buildRaisedButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          print(recipe.toJson());
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Processing Data')));
        }
      },
      child: Text('Submit'),
    );
  }
}