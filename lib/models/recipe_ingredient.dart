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

  RecipeIngredient copyWith({
    double amount,
    String unit,
    String ingredientName,
  }) {
    return RecipeIngredient(
      ingredientName: ingredientName ?? this.ingredientName,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
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
    var newAmount = amount == null ? null : amount / oldServings * newServings;
    return copyWith(amount: newAmount);
  }
}
