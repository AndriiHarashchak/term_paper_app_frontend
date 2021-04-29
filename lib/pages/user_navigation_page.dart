import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/pages/custom_app_drawer.dart';
import 'package:term_paper_app_frontend/pages/search_page.dart';
import 'package:term_paper_app_frontend/pages/user_register_page.dart';

class Usernavigationpage extends StatefulWidget {
  @override
  _UsernavigationpageState createState() => _UsernavigationpageState();
}

class _UsernavigationpageState extends State<Usernavigationpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Абоненти"),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                child: Text("Інформація про абонента"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SearchPage(
                              type: SearchType.user,
                              title: "Пошук абонента",
                            )),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                child: Text("Реєстрація абонента"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserRegisterPage()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
