import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students_app/Controllers/databasehelper.dart';
import 'package:students_app/View/reviewAction.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String msgStatus;
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  void _showDialog(String alertType, String alertStr) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$alertType'),
            content: Text('$alertStr'),
            actions: <Widget>[
              RaisedButton(
                  child: Text('close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  _login() {
    setState(() {
      String username = _usernameController.text.trim().toLowerCase();
      String password = _passwordController.text.trim();

      if (username.isNotEmpty && password.isNotEmpty) {
        dynamic login = databaseHelper.userLogin(username, password);
        login.then((result) {
          print("result = $result");
          if (result["Error"] != null) {
            _showDialog('Error', result["Error"]);
          } else {
            if (databaseHelper.status) {
              Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new ReviewPage(),
              ));
            } else {
              _showDialog('Error', result.toString());
            }
          }
        });
      } else {
        _showDialog("Warning", 'Fill all fields');
      }
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
            child: Text("Student Login"),
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
                      TextField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Place your username',
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10)),
                      TextField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Place your password',
                        ),
                      ),
                      RaisedButton(
                        onPressed: _login,
                        color: Colors.lightBlue,
                        child: Text(
                          'login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250.0,
                        height: 20.0,
                        child: Divider(
                          color: Colors.black45,
                        ),
                      ),
                      Container(
                        height: 50,
                        color: Colors.red.shade800,
                        child: new FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, 'register/');
                          },
                          child: Text(
                            'register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
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
