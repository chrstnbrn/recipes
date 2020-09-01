import 'package:flutter/widgets.dart';

import '../../models/recipe_step.dart';
import '../../widgets/checkable_text.dart';

class RecipeDetailSteps extends StatelessWidget {
  const RecipeDetailSteps({
    Key key,
    @required this.steps,
  }) : super(key: key);

  final List<RecipeStep> steps;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: steps.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: CheckableText(text: steps[index].description),
      ),
    );
  }
}
