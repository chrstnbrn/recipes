import 'package:flutter/widgets.dart';

class ScreenBody extends StatelessWidget {
  const ScreenBody({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }
}
