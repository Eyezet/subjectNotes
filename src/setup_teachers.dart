import 'package:flutter/material.dart';
import 'input_form.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class SetupTeachers extends StatefulWidget {
  @override
  _SetupTeachersState createState() => _SetupTeachersState();
}

class _SetupTeachersState extends State<SetupTeachers> {
  List<InputForm> teacherFormList = [];
  int id = 0;
  List<dynamic> teachers = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<InputForm> teacherList = [];

  void addInputForm(List<String> initialValues) {
    setState(() {
      teacherFormList = List.from(teacherFormList)
        ..add(InputForm(removeInputForm, id, UniqueKey(), getInput, 3,
            ["Teacher", "Subject", "Color (hex)"], initialValues));
    });
    //print(teacherFormList.toString());
    id += 1;
  }

  void removeInputForm(int id) {
    //print(teacherFormList.toString());
    setState(() {
      teacherFormList.removeWhere((form) => form.id == id);
    });
    //print(teacherFormList.toString());
  }

  void getInput(Map<String, dynamic> input) {
    teachers.add(input);
  }

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

  Future<File> writeTeachers(String timetable) async {
    final file = await _localFile;
    return file.writeAsString(
      timetable,
      mode: FileMode.write,
    );
  }

  initState() {
    readTeachers()
      ..then((val) => setState(() {
            if (val == "") {
              teachers = [];
            } else {
              teachers = jsonDecode(val);

              setupTeacherList();
            }
            //print(timetable["Last Opened"]["Week"]);
          }));
    super.initState();
  }

  void setupTeacherList() {
    teacherFormList.clear();

    for (int i = 0; i < teachers.length; i++) {
      Map<String, dynamic> teacher = teachers[i];
      addInputForm(
          [teacher["Teacher"], teacher["Subject"], teacher["Color (hex)"]]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Setup Teachers"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: teacherFormList,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                iconSize: 30,
                onPressed: () {
                  addInputForm(["", "", ""]);
                },
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Save"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  teachers.clear();
                  _formKey.currentState.save();

                  //print(idTeacherSubject.toString());
                  writeTeachers(jsonEncode(teachers));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
