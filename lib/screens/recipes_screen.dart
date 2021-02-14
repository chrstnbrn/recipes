import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../routes.dart';
import '../store/recipe_repository.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key key}) : super(key: key);

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
    var repository = Provider.of<RecipeRepository>(context);
    var user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: Scrollbar(
        child: _buildRecipesList(repository.recipes(user.crewId)),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => Navigator.of(context, rootNavigator: true)
            .pushNamed(Routes.addRecipe),
        child: const Icon(Icons.add),
      ),
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
              separatorBuilder: (context, i) => const Divider());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildRow(Recipe recipe) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.recipe, arguments: {'recipeId': recipe.id}),
      title: Text(
        recipe.name,
        style: _biggerFont,
      ),
    );
  }
}
