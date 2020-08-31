import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckableText extends StatefulWidget {
  const CheckableText({Key key, this.text}) : super(key: key);

  final String text;

  @override
  State<StatefulWidget> createState() => _CheckableTextState();
}

class _CheckableTextState extends State<CheckableText> {
  bool crossed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          crossed = !crossed;
        });
      },
      child: Text(widget.text,
          style: TextStyle(
              decoration:
                  crossed ? TextDecoration.lineThrough : TextDecoration.none)),
    );
  }
}
