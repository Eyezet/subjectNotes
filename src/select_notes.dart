import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import './note_button.dart';

class SelectNotes extends StatefulWidget {
  @override
  _SelectNotesState createState() => _SelectNotesState();
}

class _SelectNotesState extends State<SelectNotes> {
  final TextStyle textStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  List<dynamic> teachers = [];
  List<Widget> teacherButtonList = [];
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/teachers.txt');
  }

  Future<String> readTeachers() async {
    try {
      final file = await _localFile;

      // Read the file.
      return await file.readAsString();

      //print(note);
    } catch (e) {
      //print("error in readTimetable() setup timetable");
      return "";
    }
  }
/*
  @override
  initState() {
    readTeachers()
      ..then((val) => setState(() {
            if (val == "") {
              teachers = [];
            } else {
              teachers = jsonDecode(val);

              setupTeacherButtonList();
            }
            //print(timetable["Last Opened"]["Week"]);
          }));
    super.initState();
  }*/

  void setupTeacherButtonList() {
    teacherButtonList.clear();

    for (int i = 0; i < teachers.length; i++) {
      Map<String, dynamic> teacher = teachers[i];

      teacherButtonList.add(NoteButton(teacher["Teacher"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readTeachers()
        ..then((val) {
          if (val == "") {
            teachers = [];
          } else {
            teachers = jsonDecode(val);

            setupTeacherButtonList();
          }
          //print(timetable["Last Opened"]["Week"]);
        }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return ListView(
              children: teacherButtonList,
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
