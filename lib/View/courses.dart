import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_app/Controllers/databasehelper.dart';
import 'package:students_app/View/courseMaterials.dart';
import 'package:students_app/View/login.dart';
import 'package:students_app/View/reviewAction.dart';

/*            All Courses              */

class AllCoursesPage extends StatefulWidget {
  AllCoursesPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  AllCoursesPageState createState() => AllCoursesPageState();
}

class AllCoursesPageState extends State<AllCoursesPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int _id;

  @override
  void initState() {
    super.initState();
    databaseHelper.readId().then((result) {
      print("result: $result");
      setState(() {
        _id = int.parse(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text("All Courses"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new ReviewPage(),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage(),
                ));
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: FutureBuilder<List>(
              future: databaseHelper.getAllNewCourses(_id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return new Text('Press button to start');
                  case ConnectionState.waiting:
                    return new Icon(Icons.refresh);
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else
                      return new AllCoursesItemList(
                        list: snapshot.data,
                        studentId: _id,
                      );
                }
              },
              /************************/
//              builder: (context, snapshot) {
//                if (snapshot.hasError) print(snapshot.error);
//                return snapshot.hasData
//                    ? new ItemList(list: snapshot.data)
//                    : Center(
//                        child: CircularProgressIndicator(),
//                      );
//              },
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AllCoursesItemList extends StatelessWidget {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List list;
  int studentId;
  AllCoursesItemList({this.list, this.studentId});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => ShowCoursePage(
                          list: list,
                          index: i,
                          courseId: list[i]['id'],
                          teacherId: list[i]['teacher'],
                        )),
              ),
              child: Card(
                color: Colors.red.shade800,
                child: Column(
//                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        list[i]['name'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      leading: Image.network(
                        list[i]['main_img'],
                        height: 40,
                        width: 50,
                      ),
                      subtitle: Text(
                        'seats : ${list[i]['seats']}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FlatButton(
                      color: Colors.white,
                      child: Text('Enroll'),
                      onPressed: () {
                        databaseHelper
                            .enrollCourse(studentId, list[i]['id'])
                            .then((result) {
                          if (databaseHelper.status) {
                            Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new AllCoursesPage(),
                            ));
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

/*          Student Courses           */

class StudentCoursesPage extends StatefulWidget {
  StudentCoursesPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  StudentCoursesPageState createState() => StudentCoursesPageState();
}

class StudentCoursesPageState extends State<StudentCoursesPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int id;

  @override
  void initState() {
    super.initState();
    databaseHelper.readId().then((result) {
      print("result: $result");
      setState(() {
        id = int.parse(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text("Your Courses"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new ReviewPage(),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage(),
                ));
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: FutureBuilder<List>(
              future: databaseHelper.getStudentCourses(id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return new Text('Press button to start');
                  case ConnectionState.waiting:
                    return new Icon(Icons.refresh);
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else
                      return new StudentCoursesItemList(list: snapshot.data);
                }
              },
              /************************/
//              builder: (context, snapshot) {
//                if (snapshot.hasError) print(snapshot.error);
//                return snapshot.hasData
//                    ? new ItemList(list: snapshot.data)
//                    : Center(
//                        child: CircularProgressIndicator(),
//                      );
//              },
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class StudentCoursesItemList extends StatelessWidget {
  List list;
  StudentCoursesItemList({this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => ShowCoursePage(
                          list: list,
                          index: i,
                          courseId: list[i]['id'],
                          teacherId: list[i]['teacher'],
                        )),
              ),
              child: Card(
                color: Colors.red.shade800,
                child: ListTile(
                  title: Text(
                    list[i]['name'],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: Image.network(
                    list[i]['main_img'],
                    height: 40,
                    width: 50,
                  ),
                  subtitle: Text(
                    'seats : ${list[i]['seats']}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

/*       Show Course Details           */

// ignore: must_be_immutable
class ShowCoursePage extends StatefulWidget {
  ShowCoursePage({this.index, this.list, this.courseId, this.teacherId});
  List list;
  int index;
  int courseId;
  int teacherId;
  @override
  ShowCoursePageState createState() => ShowCoursePageState();
}

class ShowCoursePageState extends State<ShowCoursePage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Details',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text("Courses Details"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new ReviewPage(),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage(),
                ));
              },
            ),
          ],
        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 62, left: 12.0, right: 12.0, bottom: 12.0),
            children: <Widget>[
              Container(
                height: 50,
                child: Text(
                  "Name : ${widget.list[widget.index]['name']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                height: 50,
                child: Text(
                  "Time : ${widget.list[widget.index]['time']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                height: 50,
                child: Text(
                  "Seats : ${widget.list[widget.index]['seats']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                height: 50,
                child: Text(
                  "Short Description : ${widget.list[widget.index]['short_description']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                height: 50,
                child: Text(
                  "Majors : ${widget.list[widget.index]['majors']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Text(
                  " Created at : ${widget.list[widget.index]['created_on']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Text(
                  " Updated at : ${widget.list[widget.index]['modified_on']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ShowMaterialsPage(
                            courseId: widget.courseId,
                          ),
                        ),
                      );
                    },
                    color: Colors.green,
                    child: Text(
                      'Show Materials',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
