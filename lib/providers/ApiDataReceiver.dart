import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiProvider {
  //static const String _baseUrl = "localhost:12758";
  static const String _baseUrl = "10.0.2.2:12758";

  /*static const Map<String, String> _headers = {
  };*/

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
}
