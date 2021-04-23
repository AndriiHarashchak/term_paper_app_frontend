import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/promotion_model.dart';
import 'package:term_paper_app_frontend/Models/region_model.dart';
import 'package:term_paper_app_frontend/pages/promotions_page.dart';
import 'package:term_paper_app_frontend/pages/service_create_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class PromotionRegisterPage extends StatefulWidget {
  final OperationType type;
  final PromotionModel promotion;
  PromotionRegisterPage({Key key, @required this.type, this.promotion})
      : super(key: key);
  @override
  _PromotionRegisterPageState createState() => _PromotionRegisterPageState();
}

class _PromotionRegisterPageState extends State<PromotionRegisterPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _conditions;
  String _promotionName;
  String _description;
  String _activePeriod;

  List<RegionModel> regions;
  GeneralDataProvider _gdprovider;
  @override
  void initState() {
    super.initState();
    _gdprovider = GeneralDataProvider();
    if (widget.type == OperationType.update) {
      _conditions = widget.promotion.conditions;
      _description = widget.promotion.description;
      _promotionName = widget.promotion.promotionName;
      _activePeriod = widget.promotion.activePeriod.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == OperationType.create
            ? "Створення акції"
            : "Редагування акції"),
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
                          labelText: "Назва акції",
                          hintText: "Введіть назву акції"),
                      keyboardType: TextInputType.text,
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : _promotionName,
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
                      keyboardType: TextInputType.text,
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : _description,
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
                      keyboardType: TextInputType.text,
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : _conditions,
                      onChanged: (value) {
                        _conditions = value;
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
                      keyboardType: TextInputType.number,
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : _activePeriod,
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
                        child: Text(widget.type == OperationType.create
                            ? "Створити акцію"
                            : "Редагувати акцію"),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            textOK: Text(widget.type == OperationType.create
                                ? "Створити"
                                : "Редагувати"),
                            textCancel: Text("Скасувати"),
                            title: Text(widget.type == OperationType.create
                                ? "Створення акції"
                                : "Редагування акції"),
                            content: Text(widget.type == OperationType.create
                                ? "Ви впевнені, що хочете створити акцію"
                                : "Ви впевнені, що хочете редагувати акцію"),
                          )) {
                            return;
                          }
                          PromotionModel newPromotion =
                              widget.type == OperationType.create
                                  ? await registerPromotion()
                                  : await editPromotion();
                          if (newPromotion != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                    widget.type == OperationType.create
                                        ? "Успішно створено"
                                        : "Успішно редаговано")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => PromotionsPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(widget.type == OperationType.create
                                  ? "Не вдалось створити акцію"
                                  : "Не вдалось редагувати акцію"),
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
          conditions: _conditions,
          description: _description,
          activePeriod: int.parse(_activePeriod));
      var response = await _gdprovider.registerPromotion(promotion);
      return response;
    }
  }

  Future<PromotionModel> editPromotion() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      PromotionModel promotion = PromotionModel(
          promotionId: widget.promotion.promotionId,
          promotionName: _promotionName,
          conditions: _conditions,
          description: _description,
          activePeriod: int.parse(_activePeriod));
      var response = await _gdprovider.updatePromotion(promotion);
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не може бути пустим";
  }
}
