import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/Models/office_model.dart';
import 'package:term_paper_app_frontend/Models/post_model.dart';
import 'package:term_paper_app_frontend/pages/employee_page.dart';
import 'package:term_paper_app_frontend/pages/service_create_page.dart';
import 'package:term_paper_app_frontend/providers/employee_data_provider.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class EmployeeRegisterPage extends StatefulWidget {
  final OperationType type;
  final Employee employee;
  EmployeeRegisterPage({Key key, @required this.type, this.employee})
      : super(key: key);
  @override
  _EmployeeRegisterPageState createState() => _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends State<EmployeeRegisterPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _surname;
  String _name;
  String _salary;

  List<OfficeModel> offices;
  List<PostModel> posts;

  GeneralDataProvider _gdprovider;
  OfficeModel selectedOffice;
  PostModel selectedPost;
  @override
  void initState() {
    super.initState();
    () async {
      _gdprovider = GeneralDataProvider();
      offices = [];
      posts = [];
      await loadRegionsAndOffices();
      if (widget.type == OperationType.update) {
        _surname = widget.employee.surname;
        _name = widget.employee.name;
        _salary = widget.employee.salary.toString();
        selectedOffice = offices.firstWhere(
            (element) => element.officeId == widget.employee.officeRef);
        selectedPost = posts
            .firstWhere((element) => element.postId == widget.employee.postRef);
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == OperationType.update
            ? "Редагування даних"
            : "Реєстрація працівника"),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            //autovalidateMode: Auto ,
            onWillPop: () async {
              return await confirm(context,
                  title: Text("Скасування"),
                  textOK: Text(widget.type == OperationType.update
                      ? "Відмінити редагування"
                      : "Відмінити створення"),
                  textCancel: Text("Залишитись"),
                  content: Text(widget.type == OperationType.update
                      ? "Ви впевнені, що хочете скаcувати редагування даних працвника?"
                      : "Ви впевнені, що хочете скасувати реєстрацію нового працвника?")); //true if can be popped
            },
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Ім'я працівника",
                          hintText: "Введіть ім'я працівника"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _name = value;
                      },
                      initialValue: widget.type == OperationType.update
                          ? widget.employee.name
                          : "",
                      validator: validate,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Прізвище", hintText: "Введіть прізвище"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _surname = value;
                      },
                      initialValue: widget.type == OperationType.update
                          ? widget.employee.surname
                          : "",
                      validator: validate,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Заробітня плата", hintText: "Введіть зп"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _salary = value;
                      },
                      initialValue: widget.type == OperationType.update
                          ? widget.employee.salary.toString()
                          : "",
                      validator: (text) {
                        if (double.tryParse(text) != null) {
                          double value = double.parse(text);
                          if (value < 0) {
                            return "Не можу бути менше нуля";
                          }
                          if (selectedPost != null) {
                            if ((value - selectedPost.basicSalary).abs() <
                                selectedPost.basicSalary * 0.25) {}
                          }
                        } else {
                          return "Неправильне число";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonFormField<PostModel>(
                        validator: (value) =>
                            value == null ? 'Поле не можу бути пустим' : null,
                        hint: Text("Виберіть посаду"),
                        value: selectedPost,
                        onChanged: (item) {
                          setState(() {
                            selectedPost = item;
                            //loadTariffs(item.regionId);
                          });
                        },
                        items: posts.map((e) {
                          return DropdownMenuItem<PostModel>(
                            value: e,
                            child: Container(
                              child: Text(
                                e.postName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        //width: MediaQuery.of(context).size.width * 0.8,
                        child: DropdownButtonFormField<OfficeModel>(
                          validator: (value) =>
                              value == null ? 'Поле не може бути пустим' : null,
                          hint: Text("Виберіть офіс"),
                          value: selectedOffice,
                          onChanged: (item) {
                            setState(() {
                              selectedOffice = item;
                            });
                          },
                          items: offices.map((e) {
                            return DropdownMenuItem<OfficeModel>(
                              value: e,
                              child: Container(
                                child: Text(
                                  e.adress,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(widget.type == OperationType.update
                            ? "Редагувати працівника"
                            : "Зареєструвати працівника"),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            textOK: Text(widget.type == OperationType.update
                                ? "Редагувати"
                                : "Зареєструвати"),
                            textCancel: Text("Скасувати"),
                            title: Text(widget.type == OperationType.update
                                ? "Редагування працівника"
                                : "Реєстрація працівника?"),
                            content: Text(widget.type == OperationType.update
                                ? "Ви впевнені, що хочете редагувати дані працівника"
                                : "Ви впевнені, що хочете зареєструвати працівника"),
                          )) {
                            return;
                          }
                          Employee newEmployee =
                              widget.type == OperationType.update
                                  ? await editEmployee()
                                  : await registedEmployee();
                          if (newEmployee != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                    widget.type == OperationType.update
                                        ? "Успішно редаговано"
                                        : "Успішно зареєстровано")));
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => EmployeePage(
                                          isLoggedIn: false,
                                          employee: newEmployee,
                                        )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(widget.type == OperationType.update
                                  ? "Не вдалось редагувати працівника"
                                  : "Не вдалось зареєструвати працівника"),
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Employee> registedEmployee() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      EmployeeCreateModel employee = EmployeeCreateModel(
        name: _name,
        surname: _surname,
        salary: double.parse(_salary),
        postRef: selectedPost.postId,
        officeRef: selectedOffice.officeId,
      );
      var response = await EmployeeDataProvider().createEmployee(employee);
      return response;
    }
  }

  Future<Employee> editEmployee() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      EmployeeCreateModel employee = EmployeeCreateModel(
        employeeId: widget.employee.id,
        name: _name,
        surname: _surname,
        salary: double.parse(_salary),
        postRef: selectedPost.postId,
        officeRef: selectedOffice.officeId,
      );
      var response = await EmployeeDataProvider().editEmployee(employee);
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не може бути пустим";
  }

  Future<void> loadRegionsAndOffices() async {
    var postResponse = await _gdprovider.getPosts();
    var officesResponse = await _gdprovider.getOffices();
    setState(() {
      if (postResponse != null) posts = postResponse;
      if (officesResponse != null) {
        offices = officesResponse;
      }
    });
  }
}
