import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/Models/userModel.dart';
import 'package:term_paper_app_frontend/pages/employee_page.dart';
import 'package:term_paper_app_frontend/pages/user_page.dart';
import 'package:term_paper_app_frontend/providers/employee_data_provider.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

enum SearchType { user, employee }

class SearchPage extends StatefulWidget {
  final String title;
  final SearchType type;
  //final Function(String, dynamic) onTapped;
  SearchPage({Key key, @required this.title, @required this.type})
      : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdTextController = TextEditingController();
  String _errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Пошук " + widget.title.toLowerCase()),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Пошук " + widget.title.toLowerCase(),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: TextFormField(
                  controller: _userIdTextController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Поле не може бути пустим";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: " id ${widget.title.toLowerCase()}"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: checkValueAndNavigate,
                    child: Text("Пошук"),
                  ),
                ),
              ),
              Text(_errorMessage),
            ],
          ),
        ),
      ),
    );
  }

  checkValueAndNavigate() async {
    if (_formKey.currentState.validate()) {
      if (widget.type == SearchType.user) {
        UserModel response = await UserDataProvider()
            .getUserInfo(int.parse(_userIdTextController.value.text));
        if (response != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserPage(user: response)));
        } else {
          setState(() {
            _errorMessage = "Немає користувача з введеним номером телефону";
          });
        }
      } else {
        Employee employee = await EmployeeDataProvider()
            .getEmployee(int.parse(_userIdTextController.value.text));
        if (employee != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EmployeePage(
                    employee: employee,
                    isLoggedIn: false,
                  )));
        } else {
          setState(() {
            _errorMessage = "Немає працівника з введеним id";
          });
        }
      }
    }
  }
}
