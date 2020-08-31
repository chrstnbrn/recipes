import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:intl/intl.dart';

class TouchSpinFormField extends FormField<int> {
  TouchSpinFormField(
      {int initialValue,
      FormFieldSetter<int> onSaved,
      FormFieldValidator<int> validator,
      InputDecoration decoration})
      : super(
          autovalidate: false,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (state) => TouchSpinFormFieldWidget(state, decoration),
        );
}

class TouchSpinFormFieldWidget extends StatefulWidget {
  final FormFieldState<int> state;
  final InputDecoration decoration;

  TouchSpinFormFieldWidget(this.state, this.decoration);

  @override
  TouchSpinFormFieldState createState() =>
      TouchSpinFormFieldState(state, decoration);
}

class TouchSpinFormFieldState extends State<TouchSpinFormFieldWidget> {
  final FormFieldState<int> state;
  final InputDecoration decoration;

  FocusNode _focusNode;
  bool _isFocused = false;

  TouchSpinFormFieldState(this.state, this.decoration);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _isFocused) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        focusNode: _focusNode,
        child: InputDecorator(
          decoration: decoration,
          isFocused: _isFocused,
          child: TouchSpin(
              value: state.value,
              displayFormat: NumberFormat(),
              onChanged: (num value) {
                _focusNode.requestFocus();
                state.didChange(value.toInt());
              }),
        ));
  }
}
