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
          : List.from(
              ingredients.map<RecipeIngredient>(
                (dynamic x) =>
                    RecipeIngredient.fromJson(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  String description;
  List<RecipeIngredient> ingredients;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'ingredients':
            List<dynamic>.from(ingredients.map<dynamic>((x) => x.toJson())),
      };

  RecipeStep adjustAmount(int oldServings, int newServings) {
    return RecipeStep(
      description: description,
      ingredients: [
        ...ingredients.map<RecipeIngredient>(
          (e) => e.adjustAmount(oldServings, newServings),
        )
      ],
    );
  }
}
