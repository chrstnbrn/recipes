import 'package:meta/meta.dart';

abstract class RecipeDetailListItem {}

class Recipe {
  Recipe({
    @required this.id,
    @required this.name,
    @required this.servings,
    @required this.ingredients,
    @required this.steps,
  });

  factory Recipe.fromJson(String id, Map<String, dynamic> json) {
    var name = json['name'] as String;
    var servings = json['servings'] as int;
    var ingredients = json['ingredients'] as List;
    var steps = json['steps'] as List;

    return Recipe(
      id: id,
      name: name,
      servings: servings,
      ingredients: _getList<RecipeIngredient>(
        ingredients,
        (dynamic i) => RecipeIngredient.fromJson(i as Map<String, dynamic>),
      ),
      steps: _getList<RecipeStep>(
        steps,
        (dynamic x) => RecipeStep.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  String id;
  String name;
  int servings;
  List<RecipeIngredient> ingredients;
  List<RecipeStep> steps;

  static List<T> _getList<T>(List list, T Function(dynamic) f) {
    if (list == null) return [];
    return List<T>.from(list.map<T>(f), growable: true);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'servings': servings,
        'ingredients':
            List<dynamic>.from(ingredients.map<dynamic>((x) => x.toJson())),
        'steps': List<dynamic>.from(steps.map<dynamic>((x) => x.toJson())),
      };
}

class RecipeIngredient implements RecipeDetailListItem {
  RecipeIngredient({
    this.amount,
    this.unit,
    this.ingredientName,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      amount: (json['amount'] as num)?.toDouble(),
      unit: json['unit'] as String,
      ingredientName: json['ingredientName'] as String,
    );
  }

  double amount;
  String unit;
  String ingredientName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'amount': amount,
        'unit': unit,
        'ingredientName': ingredientName,
      };

  @override
  String toString() {
    var result = '';
    if (amount != null) result += '$amount ';
    if (unit != null) result += '$unit ';
    return result + ingredientName;
  }
}

class RecipeStep implements RecipeDetailListItem {
  RecipeStep({
    this.description,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
        description: json['description'] as String,
      );

  String description;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
      };
}
