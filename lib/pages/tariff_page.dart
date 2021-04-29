import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/tariff_model.dart';
import 'package:term_paper_app_frontend/pages/tariffs_page.dart';
import 'package:term_paper_app_frontend/providers/data_mapper.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class TariffPage extends StatefulWidget {
  final TariffModel tariff;
  //final Function(String, dynamic) ontapped;
  TariffPage({Key key, @required this.tariff}) : super(key: key);

  @override
  _TariffPageState createState() => _TariffPageState();
}

class _TariffPageState extends State<TariffPage> {
  TextStyle textStyle;
  @override
  void initState() {
    super.initState();
    textStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Інформація про тариф"),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed:
                  null /* () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditUserPage(user: widget.tariff))) */
              ),
        ],
      ),
      //drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Назва тарифу:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.tariffName.toString(),
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Хвилин в мережі:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.minutesWithinTheOperator.toString(),
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Хвилин на інші мережі:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.minutesToOtherOperators.toString(),
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("К-сть смс:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.smsCount.toString(),
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 4, child: Text("Кількісь мегабайт трафіку:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.internetTrafficSize.toString(),
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Вартість дзвінка:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.callPrice.toString() ?? "",
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Вартість смс:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.smsPrice.toString() ?? "",
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Місячний платіж:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.pricePerPeriod != null
                              ? widget.tariff.pricePerPeriod.toString()
                              : "0", //.toString(),
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Ід регіона:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.regionRef.toString(),
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Стан тарифу:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.tariff.isActive == true
                              ? "Тариф активний"
                              : "Тариф не активний",
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Дата рєстрації:")),
                    Expanded(
                      flex: 4,
                      child: Text(
                        DataModifier.getDate(widget.tariff.registrationDate),
                        style: textStyle,
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              () {
                if (widget.tariff.isActive) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text("Деактивувати тариф"),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            textOK: Text("Деактивувати"),
                            textCancel: Text("Скасувати"),
                            title: Text("деактивація тарифу"),
                            content: Text(
                                "Ви впевнені, що хочете деактивувати тариф?"),
                          )) {
                            return;
                          }
                          bool result =
                              await deactivateTariff(widget.tariff.tariffId);
                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text("Успішно деактивовано")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => TariffsPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text("Не вдалось деактивувати тариф"),
                            ));
                          }
                        },
                      ),
                    ),
                  );
                }
                return Container();
              }()
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> deactivateTariff(int tariffId) async {
    return await GeneralDataProvider().deactivateTariff(tariffId);
  }
}
