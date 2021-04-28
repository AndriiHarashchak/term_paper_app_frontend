import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/Models/office_model.dart';
import 'package:term_paper_app_frontend/Models/post_model.dart';
import 'package:term_paper_app_frontend/pages/employee_page.dart';
import 'package:term_paper_app_frontend/providers/employee_data_provider.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class EmployeeRegisterPage extends StatefulWidget {
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
    _gdprovider = GeneralDataProvider();
    offices = [];
    posts = [];
    loadRegionsAndOffices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Реєстрація працівника"),
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
                  textOK: Text("Відмінити створення"),
                  textCancel: Text("Залишитись"),
                  content: Text(
                      "Ви впевнені, що хочете сказувати реєстрацію нового працвника?")); //true if can be popped
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
                        child: Text("Зареєструвати працівника"),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            textOK: Text("Зареєструвати"),
                            textCancel: Text("Скасувати"),
                            title: Text("Реєстрація працівника?"),
                            content: Text(
                                "Ви впевнені, що хочете зареєструвати працівника"),
                          )) {
                            return;
                          }
                          Employee newEmployee = await registedUser();
                          if (newEmployee != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text("Успішно зареєстровано")));
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => EmployeePage(
                                          isLoggedIn: false,
                                          employee: newEmployee,
                                        )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content:
                                  Text("Не вдалось зареєструвати працівника"),
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

  Future<Employee> registedUser() async {
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
