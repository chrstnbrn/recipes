import 'package:meta/meta.dart';

class RecipeStep {
  RecipeStep({
    @required this.description,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
        description: json['description'] as String,
      );

  String description;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
      };
}
