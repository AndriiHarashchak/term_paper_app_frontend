import 'package:flutter/material.dart';
import "dart:convert";
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/Models/userModel.dart';

class EmployeeDataProvider {
  //static const _api_key = 'd24e4c26e2msh607ebb1fd0d2b75p188520jsnf6f8b27df332';
  //static const String _baseUrl = "localhost:12758";
  static const String _baseUrl = "10.0.2.2:12758";
  /*static const Map<String, String> _headers = {
    "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
    "x-rapidapi-key": _api_key,
  };*/
  Future<dynamic> getDataFromAPI(
      {@required String endpoint, @required Map<String, String> query}) async {
    Uri uri = Uri.http(_baseUrl, endpoint, query);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map;
    } else {
      print(response.reasonPhrase);
      throw Exception("failed to read data");
    }
  }

  Future<Employee> login(int login, String password) async {
    Map<String, String> params = {"id": login.toString(), "password": password};
    try {
      var response =
          await getDataFromAPI(endpoint: "api/employee/login", query: params);
      return Employee.fromJson(response);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserModel> getUserInfo(int userId) async {
    try {
      var response =
          await getDataFromAPI(endpoint: "api/user/$userId", query: null);
      return UserModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
