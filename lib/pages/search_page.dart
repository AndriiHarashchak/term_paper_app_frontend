import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/userModel.dart';
import 'package:term_paper_app_frontend/pages/user_page.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

class SearchPage extends StatefulWidget {
  final String title;
  //final Function(String, dynamic) onTapped;
  SearchPage({Key key, @required this.title}) : super(key: key);
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
        title: Text("Пошук абонента"),
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
      UserModel response = await UserDataProvider()
          .getUserInfo(int.parse(_userIdTextController.value.text));
      if (response != null) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UserPage(user: response)));
        /* setState(() {
          _errorMessage = "Navigation will be there ${response.toString()}";
        }); */
        print(response);
        //widget.onTapped(RoutesNames.user, response);
      } else {
        setState(() {
          _errorMessage = "No user with provided phone Number";
        });
      }
    }
  }
}
