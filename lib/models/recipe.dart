import 'package:meta/meta.dart';

abstract class RecipeDetailListItem {}

class Recipe {
  String id;
  String name;
  int servings;
  List<RecipeIngredient> ingredients;
  List<RecipeStep> steps;

  Recipe({
    @required this.id,
    @required this.name,
    @required this.servings,
    @required this.ingredients,
    @required this.steps,
  });

  factory Recipe.fromJson(String id, Map<String, dynamic> json) {
    var name = json['name'];
    var servings = json['servings'];
    var ingredients = json['ingredients'];
    var steps = json['steps'];

    return Recipe(
      id: id,
      name: name,
      servings: servings,
      ingredients: _getList<RecipeIngredient>(
          ingredients, (i) => RecipeIngredient.fromJson(i)),
      steps: _getList<RecipeStep>(steps, (x) => RecipeStep.fromJson(x)),
    );
  }

  static List<T> _getList<T>(dynamic list, Function(dynamic) f) {
    if (list == null) return [];
    return List<T>.from(list.map(f), growable: true);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'servings': servings,
        'ingredients': List<dynamic>.from(ingredients.map((x) => x.toJson())),
        'steps': List<dynamic>.from(steps.map((x) => x.toJson())),
      };
}

class RecipeIngredient implements RecipeDetailListItem {
  double amount;
  String unit;
  String ingredientName;

  RecipeIngredient({
    this.amount,
    this.unit,
    this.ingredientName,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      amount: json['amount'] == null ? null : json['amount'].toDouble(),
      unit: json['unit'],
      ingredientName: json['ingredientName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'unit': unit,
        'ingredientName': ingredientName,
      };

  @override
  String toString() {
    var result = '';
    if (amount != null) result += '${amount} ';
    if (unit != null) result += '${unit} ';
    result += ingredientName;
    return result;
  }
}

class RecipeStep implements RecipeDetailListItem {
  String description;

  RecipeStep({
    this.description,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'description': description,
      };
}
