import 'package:flutter_test/flutter_test.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/models/recipe_ingredient.dart';
import 'package:recipes/models/recipe_step.dart';

// ignore_for_file: lines_longer_than_80_chars

void main() {
  group('Recipe', () {
    test('can be created from JSON', () {
      var recipe = Recipe.fromJson('abc123', <String, dynamic>{
        'name': 'Tomaten-Couscous',
        'servings': 3,
        'ingredients': [
          <String, dynamic>{
            'amount': 100,
            'unit': 'g',
            'ingredientName': 'Couscous'
          },
          <String, dynamic>{'ingredientName': 'Salz'}
        ],
        'steps': [
          <String, dynamic>{'description': 'Step 1'},
          <String, dynamic>{'description': 'Step 2'},
        ]
      });

      expect(recipe.id, 'abc123');
      expect(recipe.name, 'Tomaten-Couscous');
      expect(recipe.servings, 3);

      expect(recipe.ingredients.length, 2);
      expect(recipe.ingredients[0].amount, 100);
      expect(recipe.ingredients[0].unit, 'g');
      expect(recipe.ingredients[0].ingredientName, 'Couscous');
      expect(recipe.ingredients[1].amount, null);
      expect(recipe.ingredients[1].unit, null);
      expect(recipe.ingredients[1].ingredientName, 'Salz');

      expect(recipe.steps.length, 2);
      expect(recipe.steps[0].description, 'Step 1');
      expect(recipe.steps[1].description, 'Step 2');
    });

    group('change servings', () {
      test(
          'should return recipe with adjusted servings for recipe without ingredients',
          () {
        var recipe = Recipe(
          id: 'abc123',
          name: 'Tomaten-Couscous',
          servings: 2,
          ingredients: [],
          steps: [],
        );

        var result = recipe.changeServings(3);

        expect(result.id, recipe.id);
        expect(result.name, recipe.name);
        expect(result.servings, 3);
        expect(result.ingredients.length, 0);
        expect(result.steps.length, 0);
      });

      test('should return recipe with adjusted servings and ingredient amounts',
          () {
        var recipe = Recipe(
          id: 'abc123',
          name: 'Tomaten-Couscous',
          servings: 2,
          ingredients: [
            RecipeIngredient(
                ingredientName: 'Couscous', amount: 100, unit: 'g'),
            RecipeIngredient(ingredientName: 'Salz'),
          ],
          steps: [
            RecipeStep(description: 'Step 1'),
            RecipeStep(description: 'Step 2')
          ],
        );

        var result = recipe.changeServings(3);

        expect(result.id, recipe.id);
        expect(result.name, recipe.name);
        expect(result.servings, 3);
        expect(result.ingredients.length, 2);
        expect(result.ingredients[0].ingredientName, 'Couscous');
        expect(result.ingredients[0].amount, 150);
        expect(result.ingredients[0].unit, 'g');
        expect(result.ingredients[1].ingredientName, 'Salz');
        expect(result.ingredients[1].amount, null);
        expect(result.ingredients[1].unit, null);
        expect(result.steps.length, 2);
        expect(result.steps[0].description, recipe.steps[0].description);
        expect(result.steps[1].description, recipe.steps[1].description);
      });
    });
  });
}
