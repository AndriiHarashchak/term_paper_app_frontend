import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/pages/custom_app_drawer.dart';
import 'package:flutter_session/flutter_session.dart';

class EmployeePage extends StatefulWidget {
  final Employee employee;
  EmployeePage({Key key, this.employee}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Головна сторінка"),
        ),
        drawer: CustomDrawer(),
        body: FutureBuilder(
            future: FlutterSession().get('employee'),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return getEmployeeInfo(Employee.fromJson(snapshot.data));
              return Text("No data avaliable");
            }));
  }

  Widget getEmployeeInfo(Employee employee) {
    return Column(
      children: [
        Text("Name:"),
        Text(employee.name),
        Text("Surname:"),
        Text(employee.surname)
      ],
    );
  }
}
