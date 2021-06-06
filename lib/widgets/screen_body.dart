import 'package:flutter/widgets.dart';

class ScreenBody extends StatelessWidget {
  const ScreenBody({
    Key key,
    this.child,
    this.scrollController,
  }) : super(key: key);

  final Widget child;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      controller: scrollController,
      child: child,
    );
  }
}
