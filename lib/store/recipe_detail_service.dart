import 'package:rxdart/rxdart.dart';

import '../models/recipe.dart';
import 'recipe_repository.dart';

class RecipeDetailService {
  RecipeDetailService({this.recipeId, this.crewId, this.repository});

  final String recipeId;
  final String crewId;
  final RecipeRepository repository;

  final BehaviorSubject<int> _servings = BehaviorSubject<int>.seeded(null);

  Stream<Recipe> get recipe$ => Rx.combineLatest2<Recipe, int, Recipe>(
        repository.recipe(recipeId, crewId).where((recipe) => recipe != null),
        _servings.stream,
        (recipe, servings) =>
            servings == null ? recipe : recipe.changeServings(servings),
      );

  void changeServings(int servings) {
    _servings.add(servings);
  }
}
