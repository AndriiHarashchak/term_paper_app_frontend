import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiProvider {
  String _baseUrl = "localhost:12758";
  //static const String _baseUrl = "10.0.2.2:12758";
  //static const String _baseUrl = "192.168.0.121:12758";

  /*static const Map<String, String> _headers = {
  };*/
  ApiProvider() {
    if (kIsWeb)
      _baseUrl = "localhost:12758";
    else
      _baseUrl = "10.0.2.2:12758";
  }
  Future<dynamic> getDataFromAPI(
      {@required String endpoint, @required Map<String, String> query}) async {
    Uri uri = Uri.http(_baseUrl, endpoint, query);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body); // as Map;
    } else {
      print(response.reasonPhrase);
      throw Exception("failed to read data");
    }
  }

  Future<dynamic> deleteResponceToAPI(
      {@required String endpoint, @required Map<String, String> query}) async {
    Uri uri = Uri.http(_baseUrl, endpoint, query);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty)
        return json.decode(response.body); // as Map;
    } else {
      //print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  Future<dynamic> putResponseToAPI(
      {@required String endpoint,
      @required Map<String, String> query,
      dynamic body}) async {
    Uri uri = Uri.http(_baseUrl, endpoint, query);
    final response = body != null
        ? await http.put(uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body)
        : await http.put(uri);
    if (response.statusCode == 200 || response.statusCode == 202) {
      if (response.body.isNotEmpty)
        return json.decode(response.body); // as Map;
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  Future<dynamic> postRequest(
      {@required String endpoint,
      Map<String, String> query,
      @required dynamic body}) async {
    Uri uri = Uri.http(_baseUrl, endpoint, query);
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
