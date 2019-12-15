import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:students_app/Controllers/databasehelper.dart';
import 'package:students_app/View/login.dart';
import 'package:students_app/View/reviewAction.dart';

/*   ShowMaterialsPage      */

// ignore: must_be_immutable
class ShowMaterialsPage extends StatefulWidget {
  ShowMaterialsPage({this.courseId});
  int courseId;
  @override
  ShowMaterialsPageState createState() => ShowMaterialsPageState();
}

class ShowMaterialsPageState extends State<ShowMaterialsPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<String> _files = [];

  @override
  void initState() {
    super.initState();
    databaseHelper.getCourseMaterials(widget.courseId).then((result) {
      setState(() {
        print("reult length = ${result.length}");
        for (int i = 0; i < result.length; i++) {
          _files.add(result[i]['file1'].toString());
          Image image = Image.network(result[i]['file1']);
          print("image = ${image}");
        }
      });
    });
  }

  Future<dynamic> downloadFile(String url) async {
    Directory appDocDir = await getExternalStorageDirectory();
    String dir = appDocDir.path;
    print("appDocDir = $appDocDir");
    String fileName = url.split('/').last;
    File file = new File('$dir/$fileName');
    var request = await http.get(
      url,
    );
    var bytes = await request.bodyBytes;
    await file.writeAsBytes(bytes);
    print(" path ========= ${file.path}");
  }

  ListView filesList() {
    List<Widget> myList = [];
    if (_files.length > 0) {
      for (int i = 0; i < _files.length; i++) {
//        myList.add(
//          Container(
//            child: Image.network(
//              _files[i],
//              height: 300,
//            ),
//          ),
//        );
        myList.add(
          Container(
            child: CachedNetworkImage(
              imageUrl: _files[i],
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        );
        myList.add(
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: RaisedButton(
              onPressed: () {
                downloadFile(_files[i]);
              },
              child: Text("File $i: ${_files[i].split('/').last}"),
            ),
          ),
        );
        myList.add(
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
        );
      }
    }
    return ListView(
      padding: EdgeInsets.only(top: 62, left: 12.0, right: 12.0, bottom: 12.0),
      children: myList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Details',
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.green,
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
          child: filesList(),
        ),
      ),
    );
  }
}
