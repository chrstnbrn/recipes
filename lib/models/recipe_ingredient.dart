import 'package:meta/meta.dart';

class RecipeIngredient {
  RecipeIngredient({
    this.amount,
    this.unit,
    @required this.ingredientName,
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

  RecipeIngredient adjustAmount(int oldServings, int newServings) {
    return RecipeIngredient(
      ingredientName: ingredientName,
      unit: unit,
      amount: amount == null ? null : amount / oldServings * newServings,
    );
  }
}
