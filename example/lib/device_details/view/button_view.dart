import 'package:flutter/material.dart';

class ButtonView extends StatelessWidget {
  final String _text;
  final VoidCallback action;

  ButtonView(this._text, {required this.action});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text(_text),
          onPressed: action,
        ),
      ),
    );
  }
}
