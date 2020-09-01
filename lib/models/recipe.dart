import 'package:meta/meta.dart';

import 'recipe_ingredient.dart';
import 'recipe_step.dart';

class Recipe {
  Recipe({
    @required this.id,
    @required this.name,
    @required this.servings,
    @required this.steps,
  });

  factory Recipe.fromJson(String id, Map<String, dynamic> json) {
    var name = json['name'] as String;
    var servings = json['servings'] as int;
    var steps = json['steps'] as List;

    return Recipe(
      id: id,
      name: name,
      servings: servings,
      steps: steps == null
          ? []
          : [
              ...steps.map(
                (dynamic x) => RecipeStep.fromJson(x as Map<String, dynamic>),
              ),
            ],
    );
  }

  String id;
  String name;
  int servings;
  List<RecipeStep> steps;

  List<RecipeIngredient> get ingredients {
    return [
      ...steps.expand((step) => step.ingredients).fold([], (value, element) {
        var ingredients = [...value];
        var index = ingredients.indexWhere((v) =>
            v.ingredientName == element.ingredientName &&
            v.unit == element.unit);

        if (index < 0) {
          ingredients.add(element);
        } else {
          var amount = element.amount == null
              ? null
              : element.amount + ingredients[index].amount;

          ingredients[index] = element.copyWith(amount: amount);
        }

        return ingredients;
      })
    ];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'servings': servings,
        'steps': List<dynamic>.from(steps.map<dynamic>((x) => x.toJson())),
      };

  Recipe changeServings(int newServings) {
    return Recipe(
      id: id,
      name: name,
      servings: newServings,
      steps: [...steps.map((step) => step.adjustAmount(servings, newServings))],
    );
  }
}
