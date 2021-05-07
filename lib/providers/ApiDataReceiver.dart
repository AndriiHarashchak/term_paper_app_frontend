import 'dart:convert';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show consolidateHttpClientResponseBytes, kIsWeb;
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

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
      print(response.request);
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  void requestDownload(
      {@required String endpoint, Map<String, String> query}) async {
    Uri uri = Uri.http(_baseUrl, endpoint, query);

    print(uri.toString());
    bool ok = await _checkPermission();
    if (!ok) return;
    var path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    final taskId = await FlutterDownloader.enqueue(
        url: uri.toString(),
        savedDir: path,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
        fileName: "report" + query["userId"].toString());
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = url + '/' + fileName;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }
}
