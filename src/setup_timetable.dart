import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'cycle_button.dart';
import 'input_form.dart';

class SetupTimeTable extends StatefulWidget {
  @override
  _SetupTimeTableState createState() => _SetupTimeTableState();
}

class _SetupTimeTableState extends State<SetupTimeTable> {
  //List<inputForm> day
  Map<String, dynamic> timetable;
  String selectedWeek;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> weeks = [
    "Week A",
    "Week B",
  ];
  int weekCounter = 0;

  List<String> days = [
    "Monday",
    "Tuesday",
    "Wenesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  int dayCounter = 0;

  void cycleDay(int number) {
    if (save(days[dayCounter], weeks[weekCounter])) {
      setState(() {
        if (dayCounter + number < 0) {
          dayCounter = 7 + dayCounter + number;
        } else if (dayCounter + number > 6) {
          dayCounter = -7 + dayCounter + number;
        } else {
          dayCounter += number;
        }
        setupLessonList();
      });
    }
  }

  void cycleWeek(int number) {
    if (save(days[dayCounter], weeks[weekCounter])) {
      setState(() {
        if ((weekCounter + number) % 2 == 0) {
          weekCounter = 0;
        } else
          weekCounter = 1;
        setupLessonList();
      });
    }
  }

//file io

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/timetable.txt');
  }

  Future<String> readTimetable() async {
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

  Future<File> writeTimetable(String timetable) async {
    final file = await _localFile;
    return file.writeAsString(
      timetable,
      mode: FileMode.write,
    );
  }

  @override
  initState() {
    readTimetable()
      ..then((val) => setState(() {
            if (val == "") {
              timetable = {
                "Week A": {
                  "Monday": [],
                  "Tuesday": [],
                  "Wenesday": [],
                  "Thursday": [],
                  "Friday": [],
                  "Saturday": [],
                  "Sunday": [],
                },
                "Week B": {
                  "Monday": [],
                  "Tuesday": [],
                  "Wenesday": [],
                  "Thursday": [],
                  "Friday": [],
                  "Saturday": [],
                  "Sunday": [],
                },
                "Last Opened": {
                  "Week": "Week B",
                  "Time": "${DateTime.now()}",
                }
              };
              writeTimetable(jsonEncode(timetable));
              setupLessonList();
            } else {
              timetable = jsonDecode(val);

              setupLessonList();
            }
            //print(timetable["Last Opened"]["Week"]);
            changeWeek(timetable["Last Opened"]["Week"]);
          }));
    super.initState();
  }

  void setupLessonList() {
    lessonList.clear();
    String day = days[dayCounter];
    String week = weeks[weekCounter];
    if (timetable[week][day] != null) {
      for (int i = 0; i < timetable[week][day].length; i++) {
        Map<String, dynamic> schedule = timetable[week][day][i];
        addLessonForm([
          schedule["Subject"],
          schedule["Time"],
          schedule["Location"],
          schedule["Teacher"]
        ]);
      }
    }
  }

  List<InputForm> lessonList = [];

  int id = 0;

  Map<String, FontWeight> abFontWeights = {
    "Week A": FontWeight.bold,
    "Week B": FontWeight.normal
  };

  void addLessonForm(List<String> initialValues) {
    setState(() {
      lessonList = List.from(lessonList)
        ..add(InputForm(removeLessonForm, id, UniqueKey(), getInput, 4,
            ["Subject", "Time", "Location", "Teacher"], initialValues));
    });
    //print(teacherFormList.toString());
    id += 1;
  }

  void removeLessonForm(int id) {
    //print(teacherFormList.toString());
    setState(() {
      lessonList.removeWhere((form) => form.id == id);
    });
    //print(teacherFormList.toString());
  }

  bool save(String day, String week) {
    if (timetable[week][day] != null) {
      if (_formKey.currentState.validate()) {
        timetable[week][day].clear();

        _formKey.currentState.save();

        return true;
      }
    }
    return false;
  }

  void getInput(Map<String, dynamic> input) {
    timetable[weeks[weekCounter]][days[dayCounter]].add(input);
  }

  void changeWeek(String week) {
    setState(() {
      selectedWeek = week;
      timetable["Last Opened"]["Week"] = week;
      if (week == "Week A") {
        abFontWeights["Week A"] = FontWeight.bold;
        abFontWeights["Week B"] = FontWeight.normal;
      } else if (week == "Week B") {
        abFontWeights["Week A"] = FontWeight.normal;
        abFontWeights["Week B"] = FontWeight.bold;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Setup Timetable",
          ),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CycleButton(weeks[weekCounter], cycleWeek),
                CycleButton(days[dayCounter], cycleDay),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: lessonList,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                  iconSize: 30,
                  onPressed: () {
                    addLessonForm(["", "", "", ""]);
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                  icon: Text(
                    "A",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: abFontWeights["Week A"]),
                  ),
                  iconSize: 30,
                  onPressed: () {
                    changeWeek("Week A");
                  },
                ),
                IconButton(
                  icon: Text(
                    "B",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: abFontWeights["Week B"]),
                  ),
                  iconSize: 30,
                  onPressed: () {
                    changeWeek("Week B");
                  },
                ),
              ],
            ),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Save"),
              onPressed: () {
                if (save(days[dayCounter], weeks[weekCounter])) {
                  writeTimetable(jsonEncode(timetable));
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
