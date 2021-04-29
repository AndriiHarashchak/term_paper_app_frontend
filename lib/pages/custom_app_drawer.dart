import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/pages/basedata_navigation_page.dart';
import 'package:term_paper_app_frontend/pages/employee_page.dart';
import 'package:term_paper_app_frontend/pages/employye_and_equipment_navigation_page.dart';
import 'package:term_paper_app_frontend/pages/user_navigation_page.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FlutterSession().get('employee'),
        builder: (context, snapshot) {
          return Drawer(
            child: new ListView(
              children: [
                _getGeader(
                    snapshot.hasData ? Employee.fromJson(snapshot.data) : null),
                ListTile(
                  title: Text("Абоненти"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Usernavigationpage()));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Операційні дані"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BasedataNavigationPage()));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Працівники та обладнання"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmployeeNavigationPage()));
                  },
                ),
                Divider(),
              ],
            ),
          );
        });
  }

  Widget _getGeader(Employee employee) {
    return UserAccountsDrawerHeader(
      accountName:
          employee != null ? Text("ід: " + employee.id.toString()) : Text("id"),
      accountEmail: employee != null
          ? Text(employee.name + " " + employee.surname)
          : Text("Ім'я та прізвище працівника"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          "A",
          style: TextStyle(fontSize: 40.0),
        ),
      ),
      onDetailsPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmployeePage(
                      employee: employee,
                      isLoggedIn: true,
                    )));
      },
    );
  }
}
