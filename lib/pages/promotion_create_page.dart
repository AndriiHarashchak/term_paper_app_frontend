import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/promotion_model.dart';
import 'package:term_paper_app_frontend/Models/region_model.dart';
import 'package:term_paper_app_frontend/pages/promotions_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class PromotionRegisterPage extends StatefulWidget {
  @override
  _PromotionRegisterPageState createState() => _PromotionRegisterPageState();
}

class _PromotionRegisterPageState extends State<PromotionRegisterPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _conditionsTextController = new TextEditingController();
  String conditions;
  final _promotionNameTextController = new TextEditingController();
  String _promotionName;

  final _descriptionTextController = new TextEditingController();
  String _description;

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
        title: Text("Створення акції"),
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
                      "Ви впевнені, що хочете скаcувати створення нової акції?")); //true if can be popped
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
                          hintText: "Введіть назву акції"),
                      controller: _promotionNameTextController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _promotionName = value;
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
                          labelText: "Опис", hintText: "Введіть опис акції"),
                      controller: _descriptionTextController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _description = value;
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
                          labelText: "Умови", hintText: "Введіть умови акції"),
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
                          labelText: "Активний період (діб)",
                          hintText: "Введіть термін дії акції"),
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
                        child: Text("Створити акцію"),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            textOK: Text("Створити"),
                            textCancel: Text("Скасувати"),
                            title: Text("Створення акції"),
                            content:
                                Text("Ви впевнені, що хочете створити акцію"),
                          )) {
                            return;
                          }
                          PromotionModel newPromotion =
                              await registerPromotion();
                          if (newPromotion != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text("Успішно створено")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => PromotionsPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text("Не вдалось створити акцію"),
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

  Future<PromotionModel> registerPromotion() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      PromotionModel promotion = PromotionModel(
          promotionName: _promotionName,
          conditions: conditions,
          description: _description,
          activePeriod: int.parse(_activePeriod));
      var response = await _gdprovider.registerPromotion(promotion);
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не можу бути пустим";
  }
}
