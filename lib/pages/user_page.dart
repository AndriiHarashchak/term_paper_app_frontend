import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/userModel.dart';
import 'package:term_paper_app_frontend/pages/custom_app_drawer.dart';
import 'package:term_paper_app_frontend/pages/edit_user_page.dart';
import 'package:term_paper_app_frontend/pages/user_calls_history_page.dart';
import 'package:term_paper_app_frontend/pages/user_payments_page.dart';
import 'package:term_paper_app_frontend/pages/user_promotions_page.dart';
import 'package:term_paper_app_frontend/pages/user_services_page.dart';
import 'package:term_paper_app_frontend/pages/user_sms_history_page.dart';
import 'package:term_paper_app_frontend/pages/user_tariffs_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UserPage extends StatefulWidget {
  final UserModel user;
  UserPage({Key key, @required this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextStyle textStyle;
  @override
  void initState() {
    super.initState();
    textStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = 0.0;
    if (kIsWeb) {
      containerHeight = MediaQuery.of(context).size.width / 6;
    } else {
      containerHeight = MediaQuery.of(context).size.width / 3.0;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Інформація про абонента"),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditUserPage(user: widget.user)))),
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                height: containerHeight,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Ім'я: ",
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.user.name,
                                    style: textStyle,
                                  )),
                            ),
                            Divider(),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Прізвище: ",
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.user.surname,
                                    style: textStyle,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          child: Text("Avatar"),
                          radius: containerHeight / 2,
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("Номер телефону:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.userId.toString(),
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
                    Expanded(flex: 4, child: Text("Регіон:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.region,
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
                    Expanded(flex: 4, child: Text("Тариф:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.tariffName,
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
                    Expanded(flex: 4, child: Text("Трафік (мб):")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.internetTrafficSize.toString(),
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
                    Expanded(flex: 4, child: Text("Хвилини в мережі:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.minutesWithinTheOperator.toString(),
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
                    Expanded(flex: 4, child: Text("Хвилин на інші номери:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.minutesToOtherOperators.toString() ?? "0",
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
                    Expanded(flex: 4, child: Text("Залишок коштів:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.moneyAmount.toString(),
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
                    Expanded(flex: 4, child: Text("Залишок повідомлень:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.smsCount.toString(),
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
                    Expanded(flex: 4, child: Text("Стан пакету послуг:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.activationState == true
                              ? "пакет послуг активовано"
                              : "не активовано",
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
                    Expanded(flex: 4, child: Text("Остання дата активації:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.user.lastRenewDate ?? "",
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            UserTariffsPage(userId: widget.user.userId)))
                  },
                  child: Text("Інформація про тарифи"),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              UserPromotionsPage(user: widget.user)))
                    },
                    child: Text("Акції"),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              UserServicesPage(user: widget.user)))
                    },
                    child: Text("Послуги"),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              UserCallsPage(userId: widget.user.userId)))
                    },
                    child: Text("Історія дзвінків"),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              UserSmsPage(userId: widget.user.userId)))
                    },
                    child: Text("Історія повідомлень"),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              UserPaymentsPage(userId: widget.user.userId)))
                    },
                    child: Text("Історія платежів"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
