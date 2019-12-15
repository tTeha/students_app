import 'package:flutter/material.dart';
import 'package:students_app/View/login.dart';
import 'package:students_app/View/register.dart';
import 'package:students_app/View/reviewAction.dart';

void main() {
  final String title = '';
  runApp(
    MaterialApp(
        title: 'Flutter CRUD App',
//        home: LoginPage(title: 'Flutter CRUD API'),
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          'login/': (BuildContext context) => LoginPage(),
          'dashboard/': (BuildContext context) => ReviewPage(),
          'register/': (BuildContext context) => RegisterPage(),
        }),
  );
}
