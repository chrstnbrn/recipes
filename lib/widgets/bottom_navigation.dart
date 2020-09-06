import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum NavigationItem { recipes, shoppingList }

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
          icon: Icon(Icons.home),
          title: Text('Recipes'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          title: Text('Shopping List'),
        ),
      ],
      onTap: (index) => onSelectItem(NavigationItem.values[index]),
    );
  }
}
