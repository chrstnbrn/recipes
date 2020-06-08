import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:intl/intl.dart';

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
      home: Recipes(title: 'Recipes'),
    );
  }
}

class Recipes extends StatefulWidget {
  Recipes({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipes> {
  Future<List<Recipe>> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = fetchRecipes();
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
    );
  }

  static Future<List<Recipe>> fetchRecipes() async {
    var dbId = "recipedb";
    var collectionId = "recipes";
    var now = new DateFormat("EEE, dd MMM yyyy HH:mm:ss")
            .format(new DateTime.now().toUtc()) +
        " GMT";
    var authHeader = getAuthorizationTokenUsingMasterKey(
        "GET",
        "docs",
        "dbs/$dbId/colls/$collectionId",
        now,
        "y8AM2lGItIWDXfnikbTIXDidSt8N7R08eiPan8HVy853xPoYloHATW9sbxAQfyO0RsyTrgIBBf4WnpKr15WFbw==");

    var headers = {
      "Authorization": authHeader,
      "x-ms-version": "2018-12-31",
      "x-ms-date": now
    };

    var res = await http.get(
        "https://recipe-db.documents.azure.com:443/dbs/$dbId/colls/$collectionId/docs",
        headers: headers);

    var recipeDocuments = jsonDecode(utf8.decode(res.bodyBytes))["Documents"];
    return List<Recipe>.from(
        recipeDocuments.map((recipe) => recipeFromJson(recipe)));
  }

  static String getAuthorizationTokenUsingMasterKey(String verb,
      String resourceType, String resourceId, String date, String masterKey) {
    var text = (verb ?? "").toLowerCase() +
        "\n" +
        (resourceType ?? "").toLowerCase() +
        "\n" +
        (resourceId ?? "") +
        "\n" +
        date.toLowerCase() +
        "\n" +
        "" +
        "\n";

    var body = utf8.encode(text);

    var hmacSha256 = new crypto.Hmac(crypto.sha256, base64.decode(masterKey));
    var signature = base64.encode(hmacSha256.convert(body).bytes);
    return Uri.encodeComponent("type=master&ver=1.0&sig=$signature");
  }
}
