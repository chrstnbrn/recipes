import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/screens/recipe_detail.dart';
import 'package:recipes/store/recipe_repository.dart';

import 'add_recipe.dart';

class Recipes extends StatefulWidget {
  Recipes({Key key}) : super(key: key);
  final RecipeRepository repository =
      new RecipeRepository(FirebaseDatabase.instance.reference());

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipes> {
  Stream<List<Recipe>> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = widget.repository.recipes();
  }

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildRecipesList() {
    return StreamBuilder<List<Recipe>>(
      stream: _recipes,
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
        title: Text('Recipes'),
      ),
      body: Scrollbar(child: _buildRecipesList()),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddRecipeScreen(
                    repository: widget.repository,
                  ))),
          child: Icon(Icons.add)),
    );
  }
}
