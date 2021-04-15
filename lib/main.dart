import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/pages/login_page.dart';

void main() {
  runApp(FrontendApp());
}

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
