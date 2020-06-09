//class Recipe {
//  String name;
//  List<RecipeIngredient> ingredients;
//  List<RecipeStep> steps;
//
//  Recipe(this.name, this.ingredients, this.steps);
//}
//
//class RecipeIngredient implements RecipeDetailListItem {
//  double amount;
//  String unit;
//  String ingredientName;
//
//  RecipeIngredient(this.amount, this.unit, this.ingredientName);
//}
//
//class RecipeStep  implements RecipeDetailListItem{
//  int stepNumber;
//  String description;
//
//  RecipeStep(this.stepNumber, this.description);
//}
//
import 'dart:convert';

abstract class RecipeDetailListItem {}



Recipe recipeFromJson(Map<String, dynamic> jsonMap) => Recipe.fromJson(jsonMap);

String recipeToJson(Recipe data) => json.encode(data.toJson());

class Recipe {
  String name;
  int servings;
  List<RecipeIngredient> ingredients;
  List<RecipeStep> steps;

  Recipe({
    this.name,
    this.servings,
    this.ingredients = const [],
    this.steps = const [],
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    name: json["name"],
    servings: json["servings"],
    ingredients: List<RecipeIngredient>.from(json["ingredients"].map((x) => RecipeIngredient.fromJson(x))),
    steps: List<RecipeStep>.from(json["steps"].map((x) => RecipeStep.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "servings": servings,
    "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
    "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
  };
}

class RecipeIngredient implements RecipeDetailListItem {
  int amount;
  String unit;
  String ingredientName;

  RecipeIngredient({
    this.amount,
    this.unit,
    this.ingredientName,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => RecipeIngredient(
    amount: json["amount"] == null ? null : json["amount"],
    unit: json["unit"] == null ? null : json["unit"],
    ingredientName: json["ingredientName"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount == null ? null : amount,
    "unit": unit == null ? null : unit,
    "ingredientName": ingredientName,
  };
}

class RecipeStep implements RecipeDetailListItem{
  String description;

  RecipeStep({
    this.description,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
  };
}
