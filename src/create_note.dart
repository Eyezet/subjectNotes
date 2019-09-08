import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

import './note_text_input.dart';

class CreateNote extends StatefulWidget {
  final String subject;
  final String teacher;
  final Function changeNavBar;

  CreateNote([this.subject = '', this.teacher = '', this.changeNavBar]);

  @override
  State<StatefulWidget> createState() {
    return _CreateNoteState();
  }
}

class _CreateNoteState extends State<CreateNote> {
  String subject;
  String teacher;
  String note = '';
  String task = '';
  List<dynamic> tasks = [];
  Function changeNavbar;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    String teacherFirstName = teacher.split(' ')[1];

    return File('$path/$teacherFirstName.txt');
  }

  Future<File> get _localFileTask async {
    final path = await _localPath;

    return File('$path/tasks.txt');
  }

  Future<File> writeNote(String note) async {
    final file = await _localFile;
    DateTime time = DateTime.now();

    int monthNum = time.month;
    String formatedMonthNum;
    if (monthNum < 10) {
      formatedMonthNum = '0$monthNum';
    } else {
      formatedMonthNum = monthNum.toString();
    }
    int dayNum = time.day;
    String formatedDayNum;
    if (dayNum < 10) {
      formatedDayNum = '0$dayNum';
    } else {
      formatedDayNum = dayNum.toString();
    }
    // Write the file.
    String contents = '=' * 10 +
        ' $formatedDayNum/$formatedMonthNum/${time.year} ' +
        '=' * 10 +
        '\n' +
        note +
        '\n';
    return file.writeAsString(
      contents,
      mode: FileMode.append,
    );
  }

  Future<String> readTasks() async {
    try {
      final file = await _localFileTask;

      // Read the file.

      return await file.readAsString();

      //print(note);
    } catch (e) {
      //print("error in readTimetable() setup timetable");
      return "";
    }
  }

  Future<File> writeTask() async {
    final file = await _localFileTask;

    Map<String, String> newTask = {
      "Task": "$task",
      "Teacher": "$teacher",
      "Due": "Due: "
    };
    print(tasks);
    tasks.add(newTask);
    return file.writeAsString(
      jsonEncode(tasks),
      mode: FileMode.write,
    );
  }

  void fillNote(String text) {
    note = note + text + '\n';
  }

  void addTask(String text) {
    task = text;
  }

  @override
  void initState() {
    subject = widget.subject;
    teacher = widget.teacher;
    changeNavbar = widget.changeNavBar;
    readTasks()
      ..then((val) {
        //print(val);
        if (val != "") {
          tasks = jsonDecode(val);
        }
        //print(tasks);
        //print(timetable["Last Opened"]["Week"]);
      });

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
//activates if you press on a subject button and it redirects you here (instead of using nav bar)
  NoteTextInput autoFocusRequired() {
    bool value = false;

    if (subject != '') {
      value = true;
    }
    return NoteTextInput(2, 'Topics Covered', value, fillNote);
  }

  void getSubject(String subjectInput) {
    subject = subjectInput;
  }

  void getTeacher(String teacherInput) {
    setState(() {
      teacher = teacherInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          //NoteTextInput(1, "Subject", false, getSubject, subject, false),
          NoteTextInput(1, "Teacher", false, getTeacher, teacher, false),

          autoFocusRequired(), //topics covered

          NoteTextInput(1, 'Understanding', false, fillNote),
          NoteTextInput(1, 'Questions to finish', false, addTask, '', false),
          NoteTextInput(3, 'Definitions', false, fillNote),
          NoteTextInput(5, 'Notes', false, fillNote),
          Center(
            child: FlatButton(
              onPressed: () {
                _formKey.currentState.save();
                if (teacher != '') {
                  //print(teacher);
                  writeNote(note);
                  writeTask();
                  changeNavbar(0);
                }

                //print('-' * 10 +'\n'+ note + '-' * 10);
                //readNotes();
              },
              color: Colors.blue,
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
