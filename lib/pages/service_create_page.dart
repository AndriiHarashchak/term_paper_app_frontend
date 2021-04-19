import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/promotion_model.dart';
import 'package:term_paper_app_frontend/Models/region_model.dart';
import 'package:term_paper_app_frontend/Models/service_model.dart';
import 'package:term_paper_app_frontend/pages/services_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class ServiceRegistrationDage extends StatefulWidget {
  @override
  _ServiceRegistrationDageState createState() =>
      _ServiceRegistrationDageState();
}

class _ServiceRegistrationDageState extends State<ServiceRegistrationDage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _conditionsTextController = new TextEditingController();
  String conditions;
  final _serviceNameTextController = new TextEditingController();
  String _serviceName;

  final _priceTextController = new TextEditingController();
  String _price;

  final _activePeriodTextController = new TextEditingController();
  String _activePeriod;

  List<RegionModel> regions;
  GeneralDataProvider _gdprovider;
  @override
  void initState() {
    super.initState();
    _gdprovider = GeneralDataProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Створення послуги"),
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
                      "Ви впевнені, що хочете скаcувати створення нової послуги?")); //true if can be popped
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
                          labelText: "Назва послуги",
                          hintText: "Введіть назву послуги"),
                      controller: _serviceNameTextController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _serviceName = value;
                      },
                      validator: (text) {
                        if (text.isEmpty) return "Не може бути пустим";
                        if (text.length < 3) {
                          return "Назва не може бути коротше ніж 3 символи";
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
                          labelText: "Умови",
                          hintText: "Введіть умови послуги"),
                      controller: _conditionsTextController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        conditions = value;
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
                          labelText: "Ціна", hintText: "Введіть ціну"),
                      controller: _priceTextController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _price = value;
                      },
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Поле не може бути пустим";
                        }
                        if (double.tryParse(text) == null) {
                          return "Неправильно введене значення";
                        }
                        double value = double.parse(text);
                        if (value < 0)
                          return "Значення не може бути менше нуля";
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
                          labelText: "Активний період (діб)",
                          hintText: "Введіть термін дії послуги"),
                      controller: _activePeriodTextController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _activePeriod = value;
                      },
                      validator: (text) {
                        if (text.isEmpty) return "Поле не може бути пустим";

                        if (int.tryParse(text) == null)
                          return "Значення повинне бути натуральним числом";
                        int value = int.parse(text);
                        if (value < 0) return "Число менше нуля!";
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
                        child: Text("Створити послугу"),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            textOK: Text("Зареєструвати"),
                            textCancel: Text("Скасувати"),
                            title: Text("Створення псолуги"),
                            content: Text(
                                "Ви впевнені, що хочете створити послугу?"),
                          )) {
                            return;
                          }
                          ServiceModel newService = await registerService();
                          if (newService != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text("Успішно створено")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ServicesPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text("Не вдалось створити послугу"),
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

  Future<ServiceModel> registerService() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      ServiceModel service = ServiceModel(
          serviceName: _serviceName,
          conditions: conditions,
          price: double.parse(_price),
          activePeriod: int.parse(_activePeriod));
      var response = await _gdprovider.registerService(service);
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не може бути пустим";
  }
}
