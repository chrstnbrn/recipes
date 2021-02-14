import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum NavigationItem { recipes, mealPlan, shoppingList, settings }

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key key, this.currentItem, this.onSelectItem})
      : super(key: key);

  final NavigationItem currentItem;
  final ValueChanged<NavigationItem> onSelectItem;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentItem.index,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Recipes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Meal Plan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: 'Shopping List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (index) => onSelectItem(NavigationItem.values[index]),
    );
  }
}
