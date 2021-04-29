import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/pages/custom_app_drawer.dart';
import 'package:term_paper_app_frontend/pages/employee_register_page.dart';
import 'package:term_paper_app_frontend/pages/login_page.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:term_paper_app_frontend/pages/service_create_page.dart';
import 'package:term_paper_app_frontend/providers/data_mapper.dart';

class EmployeePage extends StatefulWidget {
  final Employee employee;
  final bool isLoggedIn;
  EmployeePage({Key key, this.employee, @required this.isLoggedIn})
      : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Сторінка працівника"),
            actions: widget.isLoggedIn == true
                ? <Widget>[
                    IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () async {
                          if (await confirm(context,
                              title: Text("Вихід з програми"),
                              content: Text("Ви хочете вийти?"),
                              textOK: Text("Так"),
                              textCancel: Text("Скасувати")))
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (route) => false);
                        })
                  ]
                : null),
        drawer: CustomDrawer(),
        body: () {
          if (widget.employee != null) return getEmployeeInfo(widget.employee);
          return Center(
            child: Text("Дані не доступні"),
          );
        }());
  }

  Widget getEmployeeInfo(Employee employee) {
    TextStyle textStyle =
        TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
    double width = 0;
    if (kIsWeb)
      width = MediaQuery.of(context).size.height / 3.0;
    else
      width = MediaQuery.of(context).size.width / 3.0;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              height: width,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Ім'я: ",
                                )),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  employee.name,
                                  style: textStyle,
                                )),
                          ),
                          Divider(),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Прізвище: ",
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  employee.surname,
                                  style: textStyle,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        child: Text("Avatar"),
                        radius: width / 2.0,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text("Посада:")),
                  Expanded(
                      flex: 4,
                      child: Text(
                        employee.postName.toString(),
                        style: textStyle,
                      ))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text("Офіс:")),
                  Expanded(
                      flex: 4,
                      child: Text(
                        employee.officeAdress,
                        style: textStyle,
                      ))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text("Заробітня плата (грн):")),
                  Expanded(
                      flex: 4,
                      child: Text(
                        employee.salary.toString(),
                        style: textStyle,
                      ))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text("Ідентифікатор:")),
                  Expanded(
                      flex: 4,
                      child: Text(
                        employee.id.toString(),
                        style: textStyle,
                      ))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text("Дата найму:")),
                  Expanded(
                      flex: 4,
                      child: Text(
                        DataModifier.getDate(employee.hiringDate),
                        style: textStyle,
                      ))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text("Пароль:")),
                  Expanded(
                      flex: 4,
                      child: Text(
                        employee.password ?? "",
                        style: textStyle,
                      ))
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text("Дата звільнення:")),
                  Expanded(
                      flex: 4,
                      child: Text(
                        employee.dismissalDate != null &&
                                employee.dismissalDate.isNotEmpty
                            ? DataModifier.getDate(employee.dismissalDate)
                            : "",
                        style: textStyle,
                      ))
                ],
              ),
            ),
            Divider(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EmployeeRegisterPage(
                            employee: widget.employee,
                            type: OperationType.update,
                          )))
                },
                child: Text("Редагування даних"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
