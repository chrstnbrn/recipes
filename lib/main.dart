import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipes/screens/login.dart';
import 'package:recipes/theme/style.dart';

void main() => runApp(RecipesApp());

class RecipesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CircularProgressIndicator(
              backgroundColor: Theme.of(context).errorColor,
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
                title: 'Login', theme: appTheme(), home: Login());
          }

          return CircularProgressIndicator();
        });
  }
}
