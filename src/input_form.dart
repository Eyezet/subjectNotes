import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  final Function removeFromList;
  final int id;
  final Key key;
  final Function sendInput;
  final int numForms;
  final List<String> hintValues;
  final List<String> initialValues;

  InputForm(this.removeFromList, this.id, this.key, this.sendInput,
      this.numForms, this.hintValues, this.initialValues);

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  Function removeFromList;
  int id;
  Key key;
  Function sendInput;
  Map<String, dynamic> formData = {};
  int numForms;
  List<String> hintValues;
  List<Widget> inputForms = [];
  List<String> initialValues = [];

  @override
  void initState() {
    removeFromList = widget.removeFromList;
    id = widget.id;
    key = widget.key;
    sendInput = widget.sendInput;
    numForms = widget.numForms;
    hintValues = widget.hintValues;
    initialValues = widget.initialValues;

    for (int i = 0; i < numForms; i++) {
      if (i != numForms - 1) {
        inputForms.add(
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: hintValues[i],
                ),
                initialValue: initialValues[i],
                validator: (String input) {
                  if (input.isEmpty) {
                    return ("Please enter information.");
                  } else {
                    return null;
                  }
                },
                onSaved: (input) {
                  formData[hintValues[i]] = input;
                },
              ),
            ),
          ),
        );
      } else {
        inputForms.add(
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: hintValues[i],
                ),
                initialValue: initialValues[i],
                validator: (String input) {
                  if (input.isEmpty) {
                    return ("Please enter information.");
                  } else {
                    return null;
                  }
                },
                onSaved: (input) {
                  formData[hintValues[i]] = input;

                  sendInput(formData);
                  //Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          iconSize: 30,
          icon: Icon(
            Icons.remove,
          ),
          color: Colors.redAccent,
          onPressed: () {
            removeFromList(id);
          },
        ),
        Card(
          child: SizedBox(
            //size: Size(100, 50),
            height: 165,
            width: 300,
            child: Column(
              children: inputForms,
            ),
          ),
        ),
      ],
    );
  }
}
