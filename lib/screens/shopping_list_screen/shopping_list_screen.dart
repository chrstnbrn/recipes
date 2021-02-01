import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/recipe_ingredient.dart';
import '../../models/shopping_list.dart';
import '../../models/shopping_list_item.dart';
import '../../models/user.dart';
import '../../store/shopping_list_repository.dart';
import '../../widgets/draggable_list.dart';
import '../../widgets/screen_body.dart';
import '../recipe_step_screen/ingredient_form.dart';
import 'checkable_shopping_list_item.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<ShoppingListRepository>(context);
    var user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ScreenBody(child: _buildShoppingList(repository, user)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog<RecipeIngredient>(
            context: context,
            child: _buildAddItemDialog(repository, user),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddItemDialog(ShoppingListRepository repository, User user) {
    final ingredient = RecipeIngredient(ingredientName: '');
    return AlertDialog(
      title: const Text('Add item'),
      content: IngredientForm(
        ingredient: ingredient,
        onSubmit: (ingredient) {
          var item = ShoppingListItem(
            name: ingredient.ingredientName,
            amount: ingredient.amount,
            unit: ingredient.unit,
            checked: false,
          );
          repository.addItem(item, user.crewId);
        },
      ),
    );
  }

  Widget _buildShoppingList(ShoppingListRepository repository, User user) {
    return StreamBuilder<ShoppingList>(
      stream: repository.shoppingList(user.crewId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return DraggableList<ShoppingListItem>(
          items: snapshot.data.items,
          swipeToDelete: true,
          onDelete: (item, index) =>
              repository.deleteItem(item.id, user.crewId),
          itemBuilder: (context, item, index) =>
              CheckableShoppingListItem(item: item),
        );
      },
    );
  }
}
