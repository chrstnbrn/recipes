import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'router.dart';
import 'routes.dart';
import 'store/recipe_repository.dart';
import 'theme/style.dart';

void main() => runApp(const RecipesApp());

class RecipesApp extends StatelessWidget {
  const RecipesApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp().then(
          (value) => FirebaseDatabase.instance.setPersistenceEnabled(true),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CircularProgressIndicator(
              backgroundColor: Theme.of(context).errorColor,
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>(
                  create: (context) => AuthProvider(),
                ),
                Provider<RecipeRepository>(
                  create: (context) => RecipeRepository(
                    FirebaseDatabase.instance.reference(),
                  ),
                ),
              ],
              child: Builder(
                builder: (context) {
                  var authProvider = Provider.of<AuthProvider>(context);
                  return MaterialApp(
                      title: 'Recipes',
                      theme: appTheme(),
                      initialRoute: authProvider.isAuthenticated
                          ? Routes.recipes
                          : Routes.login,
                      onGenerateRoute: Router.generateRoute);
                },
              ),
            );
          }

          return const CircularProgressIndicator();
        });
  }
}
