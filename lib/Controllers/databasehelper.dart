import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  String serverURL = "http://teha43.pythonanywhere.com";
  bool status = false;
  var token = '';
  List<String> dataList = [];
  String error = '';

  Future<dynamic> userLogin(String username, String password) async {
//    print("username = $username, password = $password");
    String myURL = "$serverURL/login/";
    final response = await http.post(
      myURL,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'username': '$username',
        'password': '$password',
      },
    );
    var data = json.decode(response.body);
//    print('statusCode = ${response.statusCode}');
//    print('body = ${response.body}');
    if (response.statusCode == 200) {
      status = true;
      if (data["Error"] == null) {
//      print('data : ${data["token"]}');
        _saveToken(data["token"]);
        _saveId(data['user']['id']);
      }
      return data;
    }
    status = false;
    return data;
  }

  Future<dynamic> userRegister(String username, String password) async {
    String myURL = "$serverURL/register/";
    final response = await http.post(
      myURL,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'username': '$username',
        'password': '$password',
        'is_student': 'true',
      },
    );
    var data = json.decode(response.body);
//    print('statusCode = ${response.statusCode}');
//    print('body = ${data}');
    if (response.statusCode == 201) {
//      print('register data : ${data}');
      status = true;
      return data;
    }
    status = false;
    return data;
  }

  Future<dynamic> addCourse(List courseData, File imgFile, int id) async {
    String myURL = "$serverURL/teacher/$id/courses/";
    FormData formData = new FormData.fromMap({
      "name": "${courseData[0]}",
      "time": "${courseData[1]}",
      "seats": "${courseData[2]}",
      "short_description": "${courseData[3]}",
      "main_img": await MultipartFile.fromFile(imgFile.path,
          filename: "${imgFile.path.split('/').last}"),
      "majors": "${courseData[4]}",
    });
    Response _response;
    try {
      Dio dio = new Dio();
      _response = await dio.post(myURL, data: formData);
    } catch (e) {
      status = false;
      print(e);
    }
    if (_response.statusCode == 201) {
      status = true;
      return _response.data;
    }
    return [false];
  }

  Future<dynamic> enrollCourse(int studentId, int courseId) async {
    String myURL = "$serverURL/student/$studentId/studentcourses/";

    Response _response;
    try {
      Dio dio = new Dio();
      _response = await dio.post(
        myURL,
        data: {
          "course": courseId,
        },
      );
    } catch (e) {
      status = false;
      print(e);
    }
    if (_response.statusCode == 201) {
      status = true;
      return _response.data;
    }
    return [false];
  }

  Future<List> getStudentCourses(int id) async {
    String myURL = "$serverURL/student/$id/courses/";
    Response dioResponse;
    try {
      Dio dio = new Dio();
      dioResponse = await dio.get(myURL);
      print("dio data = ${dioResponse.data}");
      print("dio headers = ${dioResponse.headers}");
      print("dio request = ${dioResponse.request}");
      print("dio statusCode = ${dioResponse.statusCode}");
    } catch (e) {
      print(e);
    }
    if (dioResponse.statusCode == 200) return dioResponse.data;
    return [false];
  }

  Future<List> getAllNewCourses(int id) async {
    String myURL = "$serverURL/new/$id/courses/";
    Response dioResponse;
    try {
      Dio dio = new Dio();
      dioResponse = await dio.get(myURL);
      print("dio data = ${dioResponse.data}");
      print("dio headers = ${dioResponse.headers}");
      print("dio request = ${dioResponse.request}");
      print("dio statusCode = ${dioResponse.statusCode}");
    } catch (e) {
      print(e);
    }
    if (dioResponse.statusCode == 200) return dioResponse.data;
    return [false];
  }

  Future<List> getCourseMaterials(int id) async {
    String myURL = "$serverURL/course/$id/materials/";
    Response dioResponse;
    try {
      Dio dio = new Dio();
      dioResponse = await dio.get(myURL);
      print("dio data = ${dioResponse.data}");
      print("dio headers = ${dioResponse.headers}");
      print("dio request = ${dioResponse.request}");
      print("dio statusCode = ${dioResponse.statusCode}");
    } catch (e) {
      print(e);
    }
    if (dioResponse.statusCode == 200) return dioResponse.data;
    return [false];
  }

  _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  _saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'student_id';
    final value = '$id';
    prefs.setString(key, value);
  }

  Future<String> readId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'student_id';
    final value = prefs.get(key) ?? 0;
    print('read id : $value');
    return value;
  }

  Future<String> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read toke : $value');
    return value;
  }

  clearSP() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
