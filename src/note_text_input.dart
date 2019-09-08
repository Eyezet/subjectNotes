import 'package:flutter/material.dart';

class NoteTextInput extends StatefulWidget {
  final int min;
  final String displayedText;
  final bool autoFocus;
  final Function forwardText;
  final String initialVal;
  final bool formated;
  NoteTextInput([
    this.min,
    this.displayedText,
    this.autoFocus,
    this.forwardText,
    this.initialVal = '',
    this.formated = true,
  ]);
  @override
  _NoteTextInputState createState() => _NoteTextInputState();
}

class _NoteTextInputState extends State<NoteTextInput> {
  int min;
  String displayedText;
  bool autoFocus;
  Function forwardText;
  String initialVal;
  bool formated;

  @override
  void initState() {
    min = widget.min;
    displayedText = widget.displayedText;
    autoFocus = widget.autoFocus;
    forwardText = widget.forwardText;
    initialVal = widget.initialVal;
    formated = widget.formated;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      child: TextFormField(
        initialValue: initialVal,
        onSaved: (value) {
          if (formated) {
            forwardText('$displayedText: ' + value);
          } else {
            forwardText(value);
            //print("$displayedText $value");
          }
        },
        autofocus: autoFocus,
        minLines: min,
        maxLines: null,
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: displayedText,
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
