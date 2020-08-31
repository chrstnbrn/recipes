class RecipeStep {
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
