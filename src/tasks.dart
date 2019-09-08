import 'package:flutter/widgets.dart';
import 'input_form.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<InputForm> taskList = [];
  List<dynamic> tasks = [
    //{"Task": "Test", "Teacher": "Taf", "Due": "15/09"}
  ];
  int id = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/tasks.txt');
  }

  Future<String> readTasks() async {
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

  Future<File> writeTasks() async {
    final file = await _localFile;

    return file.writeAsString(
      jsonEncode(tasks),
      mode: FileMode.write,
    );
  }

  void getInput(Map<String, dynamic> input) {
    tasks.add(input);
  }

  void addTask(List<String> initialValues) {
    setState(() {
      taskList = List.from(taskList)
        ..add(InputForm(removeTask, id, UniqueKey(), getInput, 3,
            ["Task", "Teacher", "Due"], initialValues));

      //print(teacherFormList.toString());
      id += 1;
    });
  }

  void removeTask(int id) {
    //print(teacherFormList.toString());

    setState(() {
      taskList = List.from(taskList)..removeWhere((form) => form.id == id);
      writeTasks();
    });

    //print(teacherFormList.toString());
  }

  void setupTaskList() {
    //taskList.clear();
    setState(() {
      for (int i = 0; i < tasks.length; i++) {
        Map<String, dynamic> task = tasks[i];
        taskList = List.from(taskList)
          ..add(InputForm(removeTask, id, UniqueKey(), getInput, 3, [
            "Task",
            "Teacher",
            "Due"
          ], [
            task["Task"],
            task["Teacher"],
            task["Due"],
          ]));

        //print(teacherFormList.toString());
        id += 1;
      }
    });

//InputForm(this.removeFromList, this.id, this.key, this.sendInput,
    //  this.numForms, this.hintValues, this.initialValues);
  }

  @override
  void initState() {
    readTasks()
      ..then((val) {
        if (val != "") {
          tasks = jsonDecode(val);
          //print(tasks);
          setupTaskList();
        }

        //print(timetable["Last Opened"]["Week"]);
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              children: taskList,
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
              addTask(["", "", ""]);
              build(context);
            },
          ),
        ),
        FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text("Save"),
          onPressed: () {
            //print("saving");
            if (_formKey.currentState.validate()) {
              tasks.clear();
              _formKey.currentState.save();

              //print(idTeacherSubject.toString());
              writeTasks();
              //Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
