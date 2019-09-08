import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import './subject_button.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class DaySchedual extends StatefulWidget {
  final Function changeNavBar;
  DaySchedual(this.changeNavBar);

  @override
  _DaySchedualState createState() => _DaySchedualState();
}

class _DaySchedualState extends State<DaySchedual> {
  Map<String, dynamic> timetable;
  List<SubjectButton> subjectButtonList = [];
  String week;
  String day;
  List<dynamic> teachers = [];
  DateTime timeNow = DateTime.now();
  List<String> days = [
    "Monday",
    "Tuesday",
    "Wenesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  /*
  
  add something to get week A/B
  fix setup teacher saving
  remove hard coded note viewer
  */

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/timetable.txt');
  }

  Future<File> get _localFileTeachers async {
    final path = await _localPath;

    return File('$path/teachers.txt');
  }

  Future<String> readTeachers() async {
    try {
      final file = await _localFileTeachers;

      // Read the file.
      return await file.readAsString();

      //print(note);
    } catch (e) {
      //print("error in readTimetable()");
      return "";
    }
  }

  Future<String> readTimetable() async {
    try {
      final file = await _localFile;

      // Read the file.
      return await file.readAsString();

      //print(note);
    } catch (e) {
      //print("error in readTimetable()");
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

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  Function changeNavBar;
  @override
  void initState() {
    changeNavBar = widget.changeNavBar;
    refresh();

    super.initState();
  }

  void refresh() {
    timeNow = DateTime.now();
    //may be a bug at midnight refresh button changes week but not day
    readTeachers()
      ..then((val) => setState(() {
            if (val != "") {
              teachers = jsonDecode(val);
            }
          }));
    readTimetable()
      ..then((val) => setState(() {
            if (val != "") {
              timetable = jsonDecode(val);
              //week = timetable["Last Opened"]["Week"];
              handleWeek(timetable["Last Opened"]["Time"]);
              day = days[timeNow.weekday - 1];
              setupSubjectButtonList();
            }
          }));
  }

  void handleWeek(String lastOpenedTime) {
    DateTime lastOpened = DateTime.parse(lastOpenedTime);
    int lastOpenedWeekNumber = weekNumber(lastOpened);
    DateTime now = DateTime.now();
    int nowWeekNumber = weekNumber(now);
    int weekDifference = nowWeekNumber - lastOpenedWeekNumber;
    setState(() {
      if (weekDifference % 2 == 1) {
        if (timetable["Last Opened"]["Week"] == "Week A") {
          week = "Week B";
        } else if (timetable["Last Opened"]["Week"] == "Week B") {
          week = "Week A";
        }
      } else {
        week = timetable["Last Opened"]["Week"];
      }
      timetable["Last Opened"]["Week"] = week;
      timetable["Last Opened"]["Time"] = now.toString();
      writeTimetable(jsonEncode(timetable));
    });
  }

  Color teacherColor(String teacherName) {
    Color color = Colors.white;
    for (int i = 0; i < teachers.length; i++) {
      if (teachers[i]["Teacher"] == teacherName) {
        color = Color(
            int.parse(teachers[i]["Color (hex)"].substring(1, 7), radix: 16) +
                0x88000000);
      }
    }
    return color;
  }

  void setupSubjectButtonList() {
    subjectButtonList.clear();
    if (timetable[week][day] != null) {
      for (int i = 0; i < timetable[week][day].length; i++) {
        Map<String, dynamic> schedule = timetable[week][day][i];
        Color color = teacherColor(schedule["Teacher"]);
        addSubjectButton(schedule["Subject"], schedule["Time"],
            schedule["Location"], schedule["Teacher"], color);
      }
    }
  }

  void addSubjectButton(String subject, String time, String location,
      String teacher, Color color) {
    setState(() {
      subjectButtonList = List.from(subjectButtonList)
        ..add(SubjectButton(
            changeNavBar, subject, teacher, time, location, color));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              " $week",
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
            IconButton(
              color: Colors.blue,
              icon: Icon(Icons.refresh),
              onPressed: () {
                refresh();
              },
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 20.0,
            ),
            children: subjectButtonList,
          ),
        ),
      ],
    );
  }
}
