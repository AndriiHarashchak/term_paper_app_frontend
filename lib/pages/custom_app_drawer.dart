import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/pages/employee_page.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: [
          _getGeader(),
          ListTile(
            title: Text("Користувачі"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => null));
            },
          ),
          ListTile(
            title: Text("управління контентом"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => null));
            },
          ),
          ListTile(
            title: Text("Обладнання"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => null));
            },
          )
        ],
      ),
    );
  }

  Widget _getGeader() {
    return UserAccountsDrawerHeader(
      accountName: Text("Ashish Rawat"),
      accountEmail: Text("ashishrawat2911@gmail.com"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
            ? Colors.blue
            : Colors.white,
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
                      employee: Employee(),
                    )));
      },
    );
  }
}
