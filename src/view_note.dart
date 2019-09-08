import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class ViewNote extends StatefulWidget {
  final String teacher;
  ViewNote(this.teacher);
  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  String teacher;

  String note = '';

  @override
  void initState() {
    teacher = widget.teacher;
    readNote().then((val) => setState(() {
          note = val;
          //print(note);
        }));
    super.initState();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    String teacherFirstName = teacher.split(' ')[1];

    return File('$path/$teacherFirstName.txt');
  }

  Future<String> readNote() async {
    try {
      final file = await _localFile;

      // Read the file.
      return await file.readAsString();
      //print(note);
    } catch (e) {
      return '';
    }
  }

  Future<File> writeNote(String note) async {
    final file = await _localFile;
    return file.writeAsString(
      note,
      mode: FileMode.write,
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            teacher,
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: readNote(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return Form(
                          key: _formKey,
                          child: TextFormField(
                            initialValue: note,
                            maxLines: null,
                            onSaved: (value) {
                              writeNote(value);
                            },
                          ),
                        );
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Center(
                child: FlatButton(
                  onPressed: () {
                    _formKey.currentState.save();
                    Navigator.pop(context);
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
        ),
      ),
    );
  }
}
