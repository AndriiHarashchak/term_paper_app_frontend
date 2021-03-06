import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:term_paper_app_frontend/Models/service_model.dart';
import 'package:term_paper_app_frontend/Models/tariff_model.dart';
import 'package:term_paper_app_frontend/pages/services_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

enum OperationType { create, update }

class ServiceRegistrationPage extends StatefulWidget {
  final OperationType type;
  final ServiceModel service;
  ServiceRegistrationPage({Key key, @required this.type, this.service})
      : super(key: key);
  @override
  _ServiceRegistrationPageState createState() =>
      _ServiceRegistrationPageState();
}

class _ServiceRegistrationPageState extends State<ServiceRegistrationPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String conditions;
  String _serviceName;
  String _price;
  String _activePeriod;

  List<TariffModel> tariffs;
  List<TariffModel> _selectedTariffs;
  //List<RegionModel> regions;
  GeneralDataProvider _gdprovider;
  @override
  void initState() {
    super.initState();
    if (widget.type == OperationType.update) {
      conditions = widget.service.conditions;
      _serviceName = widget.service.serviceName;
      _price = widget.service.price.toString();
      _activePeriod = widget.service.activePeriod.toString();
    }

    _gdprovider = GeneralDataProvider();
    tariffs = [];
    loadTariffs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == OperationType.create
            ? "Створення послуги"
            : "Редагування послуги"),
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
                  textOK: Text(widget.type == OperationType.create
                      ? "Відмінити створення"
                      : "Відмінити редагування"),
                  textCancel: Text("Залишитись"),
                  content: Text(widget.type == OperationType.create
                      ? "Ви впевнені, що хочете скаcувати створення нової послуги?"
                      : "Ви впевнені, що хочете скаcувати редагування послуги?")); //true if can be popped
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
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : widget.service.serviceName,
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
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : widget.service.conditions,
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
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : widget.service.price.toString(),
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
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : widget.service.activePeriod.toString(),
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: MultiSelectDialogField(
                      title: Text("Виберіть тарифи для послуги"),
                      items: tariffs
                          .map((e) => MultiSelectItem(e, e.tariffName))
                          .toList(),
                      listType: MultiSelectListType.LIST,
                      onConfirm: (values) {
                        _selectedTariffs = values;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(widget.type == OperationType.create
                            ? "Створити послугу"
                            : "Редагувати послугу"),
                        onPressed: () async {
                          String title = widget.type == OperationType.create
                              ? "Зареєструвати"
                              : "Редагувати";
                          if (!await confirm(
                            context,
                            textOK: Text(title),
                            textCancel: Text("Скасувати"),
                            title: Text(widget.type == OperationType.create
                                ? "Реєстрація послуги"
                                : "Редагування послуги"),
                            content: Text(
                                "Ви впевнені, що хочете ${title.toLowerCase()} послугу?"),
                          )) {
                            return;
                          }
                          ServiceModel newService =
                              widget.type == OperationType.create
                                  ? await registerService()
                                  : await editService();
                          if (newService != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                    widget.type == OperationType.create
                                        ? "Успішно створено"
                                        : "Успішно редаговано")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ServicesPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(widget.type == OperationType.create
                                  ? "Не вдалось створити послугу"
                                  : "Не вдалось редагувати послугу"),
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
      if (response != null)
        await _gdprovider.addServicesToTariff(response.serviceId,
            _selectedTariffs.map((e) => e.tariffId).toList());
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не може бути пустим";
  }

  Future<ServiceModel> editService() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) return null;
    ServiceModel newService = ServiceModel(
        serviceId: widget.service.serviceId,
        serviceName: _serviceName,
        conditions: conditions,
        price: double.parse(_price),
        activePeriod: int.parse(_activePeriod));
    return await _gdprovider.updateService(newService);
  }

  void loadTariffs() async {
    var tariffsData = await _gdprovider.getTariffs();
    if (tariffsData != null)
      setState(() {
        tariffs = tariffsData;
      });
  }
}
