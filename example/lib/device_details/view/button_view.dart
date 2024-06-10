import 'package:flutter/material.dart';

class ButtonView extends StatelessWidget {
  final String _text;
  final Function action;

  ButtonView(this._text, {required this.action});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
            textStyle: WidgetStateProperty.all<TextStyle>(
              TextStyle(color: Colors.white),
            ),
          ),
          child: Text(_text),
          onPressed: action(),
        ),
      ),
    );
  }
}
