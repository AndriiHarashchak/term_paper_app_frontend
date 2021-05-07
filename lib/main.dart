import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:term_paper_app_frontend/pages/login_page.dart';

void main() async {
  await FlutterDownloader.initialize(debug: true);
  FlutterDownloader.registerCallback(downloadCallback);
  runApp(FrontendApp());
}

void downloadCallback(String id, DownloadTaskStatus status, int progress) {}

class FrontendApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'term paper App Ui',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginScreen(),
    );
  }
}
