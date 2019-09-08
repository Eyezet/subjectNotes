import 'package:flutter/material.dart';

class CycleButton extends StatelessWidget {
  final String displayedText;
  final Function cycle;

  CycleButton(this.displayedText, this.cycle);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.navigate_before,
          ),
          onPressed: () {
            cycle(-1);
          },
        ),
        Text(displayedText),
        IconButton(
          icon: Icon(
            Icons.navigate_next,
          ),
          onPressed: () {
            cycle(1);
          },
        )
      ],
    );
  }
}
