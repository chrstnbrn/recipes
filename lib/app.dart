import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'router.dart' as recipe_router;
import 'routes.dart';
import 'widgets/bottom_navigation.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  final _defaultItem = NavigationItem.values[0];
  var _currentItem = NavigationItem.values[0];

  final Map<NavigationItem, GlobalKey<NavigatorState>> _navigatorKeys =
      Map.fromEntries(NavigationItem.values
          .map((item) => MapEntry(item, GlobalKey<NavigatorState>())));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentItem].currentState.maybePop();
        if (isFirstRouteInCurrentTab && _currentItem != _defaultItem) {
          _selectItem(_defaultItem);
          return false;
        }

        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
            children:
                NavigationItem.values.map(_buildOffstageNavigator).toList()),
        bottomNavigationBar: BottomNavigation(
          currentItem: _currentItem,
          onSelectItem: _selectItem,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(NavigationItem navigationItem) {
    return Offstage(
      offstage: _currentItem != navigationItem,
      child: Navigator(
        key: _navigatorKeys[navigationItem],
        initialRoute: _getInitialRoute(navigationItem),
        onGenerateRoute: recipe_router.Router.generateRoute,
      ),
    );
  }

  String _getInitialRoute(NavigationItem navigationItem) {
    switch (navigationItem) {
      case NavigationItem.recipes:
        return Routes.recipes;
      case NavigationItem.mealPlan:
        return Routes.mealPlan;
      case NavigationItem.shoppingList:
        return Routes.shoppingList;
      case NavigationItem.settings:
        return Routes.settings;
      default:
        throw Error();
    }
  }

  void _selectItem(NavigationItem item) {
    if (item == _currentItem) {
      // pop to first route
      _navigatorKeys[item].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentItem = item);
    }
  }
}
