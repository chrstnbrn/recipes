import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes/store/meal_plan_repository.dart';

import 'app.dart';
import 'models/user.dart';
import 'providers/auth_provider.dart';
import 'router.dart' as recipe_router;
import 'screens/login_screen.dart';
import 'store/recipe_repository.dart';
import 'store/shopping_list_repository.dart';
import 'store/user_repository.dart';
import 'theme/style.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RecipesApp());
}

class RecipesApp extends StatelessWidget {
  RecipesApp({Key key}) : super(key: key);

  final Future<void> _initialization = Firebase.initializeApp()
      .then((value) => FirebaseDatabase.instance.setPersistenceEnabled(true));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CircularProgressIndicator(
            backgroundColor: Theme.of(context).errorColor,
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: _getProviders(),
            child: Builder(
              builder: (context) {
                var authProvider = Provider.of<AuthProvider>(context);

                return StreamBuilder<User>(
                  stream: authProvider.getUser(),
                  builder: (context, snapshot) => Provider<User>(
                    create: (context) => snapshot.data,
                    builder: (context, child) => MaterialApp(
                      title: 'Recipes',
                      theme: appTheme(),
                      home:
                          snapshot.hasData ? const App() : const LoginScreen(),
                      onGenerateRoute: recipe_router.Router.generateRoute,
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }

  List<Provider> _getProviders() {
    var database = FirebaseDatabase.instance.reference();
    return [
      Provider<AuthProvider>(
        create: (context) => AuthProvider(UserRepository(database)),
      ),
      Provider<RecipeRepository>(
        create: (context) => RecipeRepository(database),
      ),
      Provider<ShoppingListRepository>(
        create: (context) => ShoppingListRepository(database),
      ),
      Provider<MealPlanRepository>(
        create: (context) => MealPlanRepository(database),
      ),
    ];
  }
}
