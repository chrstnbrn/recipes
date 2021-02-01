import 'package:meta/meta.dart';
import 'recipe_ingredient.dart';

class RecipeStep {
  RecipeStep({@required this.description, @required this.ingredients});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    var ingredients = json['ingredients'] as List;

    return RecipeStep(
      description: json['description'] as String,
      ingredients: ingredients == null
          ? []
          : ingredients
              .map((dynamic x) =>
                  RecipeIngredient.fromJson(x as Map<String, dynamic>))
              .toList(),
    );
  }

  String description;
  List<RecipeIngredient> ingredients;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'ingredients': ingredients.map((x) => x.toJson()).toList(),
      };

  RecipeStep adjustAmount(int oldServings, int newServings) {
    return RecipeStep(
      description: description,
      ingredients: ingredients
          .map((e) => e.adjustAmount(oldServings, newServings))
          .toList(),
    );
  }
}
