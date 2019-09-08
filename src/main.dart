import 'package:flutter/material.dart';
import 'package:subjectnotes/create_note.dart';
import 'package:subjectnotes/day_schedual.dart';

import './day_schedual.dart';
import './select_notes.dart';
import './setup_teachers.dart';
import './setup_timetable.dart';
import './tasks.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreeState createState() => _HomeScreeState();
}

class _HomeScreeState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String passOnSubject = '';
  String passOnTeacher = '';

  Widget getIndexWidget(int index) {
    Widget _widgetToReturn;
    switch (index) {
      case 0:
        _widgetToReturn = DaySchedual(_onItemTapped);
        break;
      case 1:
        _widgetToReturn =
            CreateNote(passOnSubject, passOnTeacher, _onItemTapped);
        break;

      case 2:
        _widgetToReturn = SelectNotes();
        break;
      case 3:
        _widgetToReturn = Tasks();
        break;
    }
    return _widgetToReturn;
  }

  List<String> _titles = <String>[
    "Schedule",
    "Create Note",
    "View Notes",
    "Tasks",
  ];

  void _onItemTapped([int index, subject = '', teacher = '']) {
    setState(() {
      passOnSubject = subject;
      passOnTeacher = teacher;

      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //return SetupApp();

    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text(
                        "Setup Teachers",
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetupTeachers()),
                        );
                      },
                    ),
                    FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text(
                        "Setup Timetable",
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetupTimeTable()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(_titles.elementAt(_selectedIndex)),
        ),
        body: getIndexWidget(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              title: Text("Schedule"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_add),
              title: Text("Add Note"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              title: Text("Notes"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              title: Text("Tasks"),
            ),
          ],
        ),
      ),
    );
  }
}
