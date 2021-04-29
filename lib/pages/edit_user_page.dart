import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/userModel.dart';
import 'package:term_paper_app_frontend/pages/user_page.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

class EditUserPage extends StatefulWidget {
  final UserModel user;
  EditUserPage({@required this.user});
  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String name;
  String surname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Зміна даних абонента"),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            onWillPop: () async {
              return await confirm(context,
                  title: Text("Скасування"),
                  textOK: Text("Відмінити зміну"),
                  textCancel: Text("Залишитись"),
                  content: Text(
                      "Ви впевнені, що хочете скаcувати зміну даних?")); //true if can be popped
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
                          labelText: "Ім'я абонента",
                          hintText: "Введіть ім'я абонента"),
                      keyboardType: TextInputType.text,
                      initialValue: widget.user.name,
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (text) {
                        if (text.isEmpty) return "Не може бути пустим";
                        if (text.length < 2) {
                          return "Ім'я не може бути коротше ніж 3 символи";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Прізвище",
                          hintText: "Введіть прізвище абонента"),
                      keyboardType: TextInputType.text,
                      initialValue: widget.user.surname,
                      onChanged: (value) {
                        surname = value;
                      },
                      validator: (text) {
                        if (text.isEmpty) return "Не може бути пустим";
                        if (text.length < 2) {
                          return "Прізвище не може бути коротше ніж 3 символи";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text("Змінити дані абонента"),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            textOK: Text("Змінити"),
                            textCancel: Text("Скасувати"),
                            title: Text("Зміна даних"),
                            content: Text(
                                "Ви впевнені, що хочете змінити дані абонента?"),
                          )) {
                            return;
                          }
                          UserModel editedUser = await editUser();
                          if (editedUser != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text("Успішно змінено")));
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => UserPage(
                                          user: editedUser,
                                        )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text("Не вдалось змінити дані абонента"),
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

  Future<UserModel> editUser() async {
    return await UserDataProvider()
        .updateUser(widget.user.userId, name, surname);
  }
}
