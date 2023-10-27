/// Made by Hugo Souza - 23/11/2023

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyNumericField extends StatefulWidget {
  late String _title;
  late String _initialValue;
  late int _decimalSize;
  late IconData? _iconData;
  late Function(dynamic value)? _onChange;

  MyNumericField({
    super.key,
    String? title,
    String? initialValue,
    int? decimalSize,
    IconData? iconData,
    Function(dynamic value)? onChange,
  }) {
    _title = title ?? '';
    _initialValue = initialValue ?? '';
    _decimalSize = decimalSize ?? 0;
    _onChange = onChange;
    _iconData = iconData;
  }

  @override
  State<MyNumericField> createState() => _MyNumericFieldState();
}

class _MyNumericFieldState extends State<MyNumericField> {
  late TextEditingController controller;
  int oldLength = 0;

  bool get isDecimalNumber => widget._decimalSize > 0;

  bool get isPointerAtTheEnd =>
      controller.selection.end == controller.text.length;

  @override
  void initState() {
    controller = TextEditingController();
    textToDouble();
    super.initState();
  }

  void textToDouble() {
    setText = double.tryParse(widget._initialValue) ?? 0;
  }

  set setText(double value) {
    controller.text = value.toStringAsFixed(widget._decimalSize);
    oldLength = controller.text.length;
    handleCursor();
  }

  void handleCursor() {
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }

  void onKeyDown(RawKeyEvent value) {
    String keyLabel = value.data.logicalKey.keyLabel;

    if (keyLabel == 'Backspace') {
      handleCursor();
    }
  }

  void settupNumber(value) {
    double conversion = (double.tryParse(value) ?? 0);

    if ((isDecimalNumber) && (isPointerAtTheEnd)) {
      if (value.length < oldLength) {
        conversion = conversion / 10.0;
      } else {
        conversion = conversion * 10.0;
      }
    }

    setText = conversion;
  }

  @override
  void didUpdateWidget(covariant MyNumericField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._initialValue != oldWidget._initialValue) {
      textToDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyTextTitle(title: widget._title),
        _inputValue(),
      ],
    );
  }

  Widget _inputValue() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (value) => onKeyDown(value),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          settupNumber(value);
          widget._onChange != null ? widget._onChange!(controller.text) : null;
        },
        decoration: InputDecoration(
          suffix: Icon(
            widget._iconData,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
