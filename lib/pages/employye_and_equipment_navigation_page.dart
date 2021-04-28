import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/pages/custom_app_drawer.dart';
import 'package:term_paper_app_frontend/pages/employee_register_page.dart';
import 'package:term_paper_app_frontend/pages/offices_page.dart';
import 'package:term_paper_app_frontend/pages/search_page.dart';

class EmployeeNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Працівники та обладнання"),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                child: Text("Працівник"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SearchPage(
                              type: SearchType.employee,
                              title: "Пошук працівника",
                            )),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                child: Text("Реєстрація працівника"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmployeeRegisterPage(),
                  ));
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                child: Text("Офіси"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OfficesPage()),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                child: Text("Інформація про обладнання"),
                onPressed: () {
                  /* Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => SearchPage(
                            title: "Пошук користувача",
                          )),
                ); */
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
