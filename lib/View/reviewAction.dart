import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_app/View/courses.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  ReviewPageState createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text("Choose an action"),
          ),
        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 62, left: 12.0, right: 12.0, bottom: 12.0),
            children: <Widget>[
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('images/course01.png'),
                        maxRadius: 50.0,
                      ),
                      Padding(padding: new EdgeInsets.all(30)),
                      SizedBox(
                        width: 250.0,
                        height: 20.0,
                        child: Divider(
                          color: Colors.black45,
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new AllCoursesPage(),
                          ));
                        },
                        color: Colors.lightBlue,
                        child: Text(
                          'All Courses',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new StudentCoursesPage(),
                          ));
                        },
                        color: Colors.lightBlue,
                        child: Text(
                          'Your Courses',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ],
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
