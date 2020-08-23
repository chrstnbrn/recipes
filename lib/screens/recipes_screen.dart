import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/providers/auth_provider.dart';
import 'package:recipes/routes.dart';
import 'package:recipes/store/recipe_repository.dart';

class RecipesScreen extends StatefulWidget {
  RecipesScreen({Key key}) : super(key: key);

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<RecipesScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var repository = Provider.of<RecipeRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: [
          FlatButton(
            textColor: Colors.white,
            child: Text('Logout'),
            onPressed: () {
              authProvider.signOut();
              Navigator.pushNamed(context, Routes.login);
            },
          )
        ],
      ),
      body: Scrollbar(child: _buildRecipesList(repository.recipes())),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, Routes.addRecipe),
          child: Icon(Icons.add)),
    );
  }

  Widget _buildRecipesList(Stream<List<Recipe>> recipes) {
    return StreamBuilder<List<Recipe>>(
      stream: recipes,
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
      onTap: () => Navigator.pushNamed(context, Routes.recipe,
          arguments: {"recipeId": recipe.id}),
      title: Text(
        recipe.name,
        style: _biggerFont,
      ),
    );
  }
}
