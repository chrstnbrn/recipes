import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/meal_plan_view_model.dart';
import '../../models/recipe.dart';
import '../../models/user.dart';
import '../../store/meal_plan_repository.dart';
import '../../store/meal_plan_service.dart';
import '../../store/recipe_repository.dart';
import '../../widgets/screen_body.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
      ),
      body: ScreenBody(
        scrollController: scrollController,
        child: _buildMealPlan(context, scrollController),
      ),
    );
  }

  Widget _buildMealPlan(
    BuildContext context,
    ScrollController scrollController,
  ) {
    var mealPlanRepository = Provider.of<MealPlanRepository>(context);
    var recipeRepository = Provider.of<RecipeRepository>(context);
    var user = Provider.of<User>(context);
    var service = MealPlanService(
      crewId: user?.crewId,
      mealPlanRepository: mealPlanRepository,
      recipeRepository: recipeRepository,
    );

    return StreamBuilder<MealPlanViewModel>(
      stream: service.mealPlanViewModel$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return Listener(
          onPointerMove: (event) {
            if (event.position.dy < 200) {
              scrollController.animateTo(scrollController.offset - 200,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            }
            if (event.position.dy > MediaQuery.of(context).size.height - 200) {
              scrollController.animateTo(scrollController.offset + 200,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            }
          },
          child: Column(
            children: [
              _buildUnplannedMeals(
                context,
                snapshot.data.unplannedMeals,
                service,
              ),
              _buildCalendar(context, snapshot.data.plannedMeals, service)
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnplannedMeals(
    BuildContext context,
    MealPlanDayViewModel mealPlanDay,
    MealPlanService mealPlanService,
  ) {
    return _buildRecipeList(context, mealPlanDay, mealPlanService);
  }

  Widget _buildCalendar(
    BuildContext context,
    List<MealPlanDayViewModel> days,
    MealPlanService mealPlanService,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          days.map((day) => _buildDay(context, day, mealPlanService)).toList(),
    );
  }

  Widget _buildDay(
    BuildContext context,
    MealPlanDayViewModel mealPlan,
    MealPlanService mealPlanService,
  ) {
    var format = DateFormat.MMMMEEEEd();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(format.format(mealPlan.day)),
          _buildRecipeList(context, mealPlan, mealPlanService),
        ],
      ),
    );
  }

  Widget _buildRecipeList(
    BuildContext context,
    MealPlanDayViewModel mealPlanDay,
    MealPlanService mealPlanService,
  ) {
    if (mealPlanDay.recipes.isEmpty) {
      return _buildDragTarget(context, (data) {
        mealPlanService.moveMeal(data.source, data.sourceIndex, mealPlanDay, 0);
      });
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) => _buildMealCard(mealPlanDay, index),
        separatorBuilder: (context, index) => _buildDragTarget(context, (data) {
          mealPlanService.moveMeal(
              data.source, data.sourceIndex, mealPlanDay, index + 1);
        }),
        itemCount: mealPlanDay.recipes.length,
      ),
    );
  }

  Widget _buildMealCard(MealPlanDayViewModel mealPlan, int index) {
    var recipe = mealPlan.recipes[index];
    return Listener(
      onPointerMove: (event) {},
      child: LongPressDraggable<DragData>(
        data: DragData(mealPlan, index),
        feedback: Container(
          height: 150,
          width: 200,
          child: _buildMealCardContent(recipe),
        ),
        childWhenDragging: Container(
          color: Colors.grey,
          height: 150,
          width: 200,
        ),
        child: Container(
          height: 150,
          width: 200,
          child: _buildMealCardContent(recipe),
        ),
      ),
    );
  }

  Widget _buildMealCardContent(Recipe recipe) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1.0,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              'https://picsum.photos/seed/${recipe.id}/200/300',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              recipe.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragTarget(
    BuildContext context,
    void Function(DragData) onAccept,
  ) {
    return DragTarget<DragData>(
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty
            ? _buildDropPreview(context)
            : Container(
                width: 20,
                height: 150,
              );
      },
      onAccept: onAccept,
    );
  }

  Widget _buildDropPreview(BuildContext context) {
    return Container(
      height: 150,
      width: 200,
      child: Card(
        color: Colors.lightBlue[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Test',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class DragData {
  DragData(
    this.source,
    this.sourceIndex,
  );

  final MealPlanDayViewModel source;
  final int sourceIndex;
}
