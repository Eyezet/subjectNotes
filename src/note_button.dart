import 'package:flutter/material.dart';

import './view_note.dart';

class NoteButton extends StatelessWidget {
  final String teacher;

  NoteButton(this.teacher);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewNote(teacher)));
      },
      title: Text(
        teacher,
        style: TextStyle(
          fontSize: 18,
          
        ),
      ),
    );
  }
}
