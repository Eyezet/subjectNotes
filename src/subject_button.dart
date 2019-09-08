import 'package:flutter/material.dart';

class SubjectButton extends StatelessWidget {
  final String subject;
  final String teacher;
  final String time;
  final String location;
  final Color color;

  final Function changeNavBar;

  SubjectButton(this.changeNavBar, this.subject, this.teacher, this.time,
      this.location, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        onPressed: () {
          changeNavBar(1, subject, teacher);
          //final BottomNavigationBar navigationBar = currentWidget;
          //navigationBar.onTap(2);
        },
        color: Colors.black12,
        //textColor: Colors.white,
        child: Container(
            child: Row(
          children: <Widget>[
            Container(
              width: 4,
              height: 40,
              color: color,
              
            ),
            Container(
              width: 6,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        subject,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        teacher,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 10,
            ),
          ],
        )),
      ),
    );
  }
}
