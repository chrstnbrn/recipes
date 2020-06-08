import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recipes/AddRecipe.dart';

import 'model/Recipe.dart';
import 'RecipeDetail.dart';

void main() => runApp(RecipesApp());

class RecipesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Recipes(
          title: 'Recipes', database: FirebaseDatabase.instance.reference()),
    );
  }
}

class Recipes extends StatefulWidget {
  Recipes({Key key, this.title, this.database}) : super(key: key);
  final String title;
  final DatabaseReference database;

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipes> {
  Future<List<Recipe>> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = fetchRecipes(widget.database);
  }

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildRecipesList() {
    return FutureBuilder<List<Recipe>>(
      future: _recipes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) => _buildRow(snapshot.data[i]),
              separatorBuilder: (context, i) => Divider());
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildRow(Recipe recipe) {
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(recipe: recipe))),
      title: Text(
        recipe.name,
        style: _biggerFont,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(child: _buildRecipesList()),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddRecipeScreen())),
          child: Icon(Icons.add)),
    );
  }

  static Future<List<Recipe>> fetchRecipes(DatabaseReference database) async {
    return database.once().then((DataSnapshot snapshot) {
      var result = jsonDecode(jsonEncode(snapshot.value));
      return List<Recipe>.from(
          result["recipes"].map((recipe) => recipeFromJson(recipe)));
    });
  }
}
