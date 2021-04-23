import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/region_model.dart';
import 'package:term_paper_app_frontend/Models/tariff_model.dart';
import 'package:term_paper_app_frontend/pages/tariff_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class TariffCreationPage extends StatefulWidget {
  @override
  _TariffCreationPageState createState() => _TariffCreationPageState();
}

class _TariffCreationPageState extends State<TariffCreationPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _tariffName;
  String _internetTrafficSize;
  String _minutesWithinTheOperator;
  String _minutesToOtherOperators;
  String _smsCount;
  String _smsPrice;
  String _callPrice;
  String _pricePerPeriod;
  RegionModel selectedRegion;
  List<RegionModel> regions;
  GeneralDataProvider _gdprovider;

  //TariffModel selectedTariff;
  //List<TariffModel> tariffs;
  @override
  void initState() {
    super.initState();
    _gdprovider = GeneralDataProvider();
    regions = [];
    //tariffs = [];
    loadRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Створення тарифу"),
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
                      "Ви впевнені, що хочете сказувати створення нового тарифу?")); //true if can be popped
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
                          labelText: "Назва тарифу",
                          hintText: "Введіть назву тарифу"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _tariffName = value;
                      },
                      validator: (text) {
                        if (text.isEmpty) return "Не може бути пустим";
                        if (text.length < 3)
                          return "Мінімальна довжина не менше 3 символів";
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
                            labelText: "К-сть інтернет трафіку (мб)",
                            hintText: "Введіть об'єм трафіку"),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _internetTrafficSize = value;
                        },
                        validator: validateInteger),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Хвилини в мережі оператора",
                          hintText: "Введіть к-сть хвилин в мережі оператора"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _minutesWithinTheOperator = value;
                      },
                      validator: validateInteger,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Хвилини в на інші оператори",
                          hintText: "Введіть к-сть хвилин на інші оператори"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _minutesToOtherOperators = value;
                      },
                      validator: validateInteger,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "К-сть смс",
                          hintText: "Введіть к-сть смс"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _smsCount = value;
                      },
                      validator: validateInteger,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Вартість дзвінка",
                          hintText: "Введіть вартість хвилини дзвінка"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _callPrice = value;
                      },
                      validator: validateDouble,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Вартість смс",
                          hintText: "Введіть вартість одного смс"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _smsPrice = value;
                      },
                      validator: validateDouble,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Вартість місячного пакету",
                          hintText: "Введіть вартість пакету на місяць"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _pricePerPeriod = value;
                      },
                      validator: validateDouble,
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
                            //loadTariffs(item.regionId);
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
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text("Створити тариф"),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            textOK: Text("Створити"),
                            textCancel: Text("Скасувати"),
                            title: Text("Створення тарифу?"),
                            content:
                                Text("Ви впевнені, що хочете створити тариф?"),
                          )) {
                            return;
                          }
                          TariffModel newTariff = await registedTariff();
                          if (newTariff != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text("Успішно створено")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TariffPage(tariff: newTariff)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text("Не вдалось створити тариф"),
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

  Future<TariffModel> registedTariff() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      TariffModel tariff = TariffModel(
          tariffName: _tariffName,
          internetTrafficSize: double.parse(_internetTrafficSize),
          minutesWithinTheOperator: double.parse(_minutesWithinTheOperator),
          minutesToOtherOperators: double.parse(_minutesToOtherOperators),
          smsCount: int.parse(_smsCount),
          smsPrice: double.parse(_smsPrice),
          callPrice: double.parse(_callPrice),
          pricePerPeriod: double.parse(_pricePerPeriod),
          regionRef: selectedRegion.regionId);
      var response = await _gdprovider.createTariff(tariff);
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не можу бути пустим";
  }

  String validateInteger(String text) {
    if (int.tryParse(text) == null) return "Не правильне значення";
    return null;
  }

  String validateDouble(String text) {
    if (double.tryParse(text) == null) return "Не правильне значення";
    return null;
  }

  Future<void> loadRegions() async {
    var regionsResponse = await _gdprovider.getRegions();
    if (regionsResponse != null)
      setState(() {
        regions = regionsResponse;
      });
  }

  /* Future<void> loadTariffs(int regionId) async {
    var tariffsResponse = await _gdprovider.getTariffs(regionId: regionId);
    if (tariffsResponse != null && tariffsResponse.length > 0)
      setState(() {
        tariffs = tariffsResponse;
      });
  } */
}
