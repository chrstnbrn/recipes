import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes/providers/auth_provider.dart';

import 'package:recipes/screens/recipes.dart';
import 'package:recipes/theme/style.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(authProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton(AuthProvider authProvider) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        authProvider.signInWithGoogle().then((value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MaterialApp(
                    title: 'Recipes', theme: appTheme(), home: Recipes());
              },
            ),
          );
        }).catchError((error) {
          print(error);
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
