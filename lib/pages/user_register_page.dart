import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/region_model.dart';
import 'package:term_paper_app_frontend/Models/tariff_model.dart';
import 'package:term_paper_app_frontend/Models/userModel.dart';
import 'package:term_paper_app_frontend/pages/user_page.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class UserRegisterPage extends StatefulWidget {
  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _surnameTextController = new TextEditingController();
  String _surname;
  final _nameTextController = new TextEditingController();
  String _name;

  final _phoneNumberTextController = new TextEditingController();
  String _phoneNumber;

  List<RegionModel> regions;
  GeneralDataProvider _gdprovider;
  RegionModel selectedRegion;
  TariffModel selectedTariff;
  List<TariffModel> tariffs;
  @override
  void initState() {
    super.initState();
    _gdprovider = GeneralDataProvider();
    regions = [];
    tariffs = [];
    loadRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Реєстрація користувача"),
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
                      "Ви впевнені, що хочете сказувати створення нового користувача?")); //true if can be popped
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
                          labelText: "Номер телефону",
                          hintText:
                              "Введіть номер телефону (написаний на упаковці від сім карти)"),
                      controller: _phoneNumberTextController,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        _phoneNumber = value;
                      },
                      validator: (text) {
                        if (text.isEmpty) return "Can`t be empty";
                        if (int.tryParse(text) == null) {
                          return "Whong phone number";
                        }
                        if (text.length != 9) return "Not correct";
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
                          labelText: "Прізвище", hintText: "Введіть прізвище"),
                      controller: _surnameTextController,
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
                          labelText: "Ім'я", hintText: "Введіть ім'я"),
                      controller: _nameTextController,
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
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonFormField<RegionModel>(
                        validator: (value) =>
                            value == null ? 'Поле не можу бути пустим' : null,
                        hint: Text("Виберіть регіон"),
                        value: selectedRegion,
                        onChanged: (item) {
                          setState(() {
                            selectedRegion = item;
                            loadTariffs(item.regionId);
                          });
                        },
                        items: regions.map((e) {
                          return DropdownMenuItem<RegionModel>(
                            value: e,
                            child: Container(
                              child: Text(
                                e.regionName,
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
                        child: DropdownButtonFormField<TariffModel>(
                          validator: (value) =>
                              value == null ? 'Поле не може бути пустим' : null,
                          hint: Text("Виберіть тариф"),
                          value: selectedTariff,
                          onChanged: selectedRegion != null
                              ? (item) {
                                  setState(() {
                                    selectedTariff = item;
                                  });
                                }
                              : null,
                          items: tariffs.map((e) {
                            return DropdownMenuItem<TariffModel>(
                              value: e,
                              child: Container(
                                child: Text(
                                  e.tariffName,
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
                        child: Text("Зареєструвати користувача"),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            textOK: Text("Зареєструвати"),
                            textCancel: Text("Скасувати"),
                            title: Text("Реєстрація користувача?"),
                            content: Text(
                                "Ви впевнені, що хочете зареєструвати користувача"),
                          )) {
                            return;
                          }
                          UserModel newUser = await registedUser();
                          if (newUser != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text("Успішно створено")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserPage(user: newUser)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content:
                                  Text("Не вдалось зареєструвати користувача"),
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

  Future<UserModel> registedUser() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      UserCreationModel user = UserCreationModel(
          phoneNumber: int.parse(_phoneNumber),
          name: _name,
          surname: _surname,
          regionId: selectedRegion.regionId,
          tariffId: selectedTariff.tariffId);
      var response = await UserDataProvider().registerUser(user);
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не можу бути пустим";
  }

  Future<void> loadRegions() async {
    var regionsResponse = await _gdprovider.getRegions();
    if (regionsResponse != null)
      setState(() {
        regions = regionsResponse;
      });
  }

  Future<void> loadTariffs(int regionId) async {
    var tariffsResponse = await _gdprovider.getTariffs(regionId: regionId);
    if (tariffsResponse != null && tariffsResponse.length > 0)
      setState(() {
        tariffs = tariffsResponse;
      });
  }
}
