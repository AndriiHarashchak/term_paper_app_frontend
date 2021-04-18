import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/promotion_model.dart';
import 'package:term_paper_app_frontend/Models/service_model.dart';
import 'package:term_paper_app_frontend/Models/user_promotion_model.dart';
import 'package:term_paper_app_frontend/Models/user_service_model.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

enum Type { service, promotion }

class ActivationPage extends StatefulWidget {
  final int tariffId;
  final int userId;
  final Type type;
  ActivationPage(
      {Key key,
      @required this.tariffId,
      @required this.userId,
      @required this.type})
      : super(key: key);
  @override
  _ActivationPageState createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  UserDataProvider _provider;
  bool isDataLoaded;
  List<bool> _isOpen;
  List<ServiceModel> services;
  List<PromotionModel> promotions;
  @override
  void initState() {
    super.initState();
    isDataLoaded = false;
    _provider = new UserDataProvider();
    if (widget.type == Type.service) loadServicesData();
    loadPromotionsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Послуги користувача"),
      ),
      //drawer: CustomDrawer(),
      body: () {
        if (widget.type == Type.service) return getServices();
        return getPromotions();
      }(),
    );
  }

  Widget getPromotions() {
    if (!isDataLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (promotions != null) {
      return ListView.builder(
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          int index = i ~/ 2;
          return ExpansionTile(
            title: Text(promotions[index].promotionName != null
                ? promotions[index].promotionName
                : "Без імені"),
            children: <Widget>[
              Container(
                //height: 50,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 1, child: Text("Опис: ")),
                        Expanded(
                          flex: 2,
                          child: Text(promotions[index].description != null
                              ? promotions[index].description
                              : ""),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Text("Умови: ")),
                        Expanded(
                          flex: 2,
                          child: Text(promotions[index].conditions != null
                              ? promotions[index].conditions
                              : ""),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            child: Text("Підключити акцію"),
                            onPressed: () async {
                              if (await confirm(context,
                                  title: Text("Підключення акції"),
                                  content: Text(
                                      "Ви впевнені, що хочете активувати акцію?"),
                                  textOK: Text("Активувати"),
                                  textCancel: Text("Скасувати"))) {
                                bool ok = await _provider.activatePromotion(
                                    widget.userId,
                                    promotions[index].promotionId);
                                if (ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text("Успішно підключено")));
                                  //loadData();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content:
                                              Text("Не вдалось підключити")));
                                }
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: promotions.length,
      );
    }
    return Center(
      child: Text("Немає доступних послуг"),
    );
  }

  Widget getServices() {
    if (!isDataLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (services != null)
      return Column(
        children: [
          ExpansionPanelList(
            children: services.map<ExpansionPanel>((e) {
              return ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return Text(e.serviceName);
                },
                body: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Умови: ")),
                          Expanded(
                            flex: 2,
                            child: Text(e.conditions),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Ціна: ")),
                          Expanded(
                            flex: 2,
                            child: Text(e.price != null
                                ? e.price.toString() + " грн"
                                : ""),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: ElevatedButton(
                            child: Text("Підключити послугу"),
                            onPressed: () async {
                              if (await confirm(context,
                                  title: Text("Підключення послуги"),
                                  content: Text(
                                      "Ви впевнені, що хочете активувати послугу?"),
                                  textOK: Text("Активувати"),
                                  textCancel: Text("Скасувати"))) {
                                bool ok = await _provider.activateService(
                                    widget.userId, e.serviceId);
                                if (ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text("Успішно підключено")));
                                  //loadData();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content:
                                              Text("Не вдалось підключити")));
                                }
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isExpanded: _isOpen[services.indexOf(e)],
              );
            }).toList(),
            expansionCallback: (i, isOpen) =>
                setState(() => _isOpen[i] = !isOpen),
          )
        ],
      );
    return Center(
      child: Text("Доступних послуг немає"),
    );
  }

  void loadServicesData() async {
    var response = await _provider.getServices(widget.tariffId);
    var userServices = await _provider.getUserServices(widget.userId);
    var userServicesHistory =
        await _provider.getUserServicesHistory(widget.userId);
    List<UserServiceModel> temp = [];
    for (var element in response) {
      if (userServices != null) {
        userServices
            .where((element1) => element1.serviceId == element.serviceId)
            .forEach((element2) {
          temp.add(element2);
        });
      }
      if (userServicesHistory != null) {
        userServicesHistory
            .where((element1) => element1.serviceId == element.serviceId)
            .forEach((element2) {
          temp.add(element2);
        });
      }
    }
    temp.forEach((element) {
      response
          .removeWhere((element1) => element1.serviceId == element.serviceId);
    });
    setState(() {
      isDataLoaded = true;
      if (response != null) {
        services = response;
        _isOpen = List.filled(response.length, false, growable: true);
      }
    });
  }

  void loadPromotionsData() async {
    var response = await _provider.getPromotions();
    var userServices = await _provider.getUserPromotions(widget.userId);
    var userServicesHistory =
        await _provider.getUserPromotionsHistory(widget.userId);
    List<UserPromotionModel> temp = [];
    for (var element in response) {
      if (userServices != null) {
        userServices
            .where((element1) => element1.promotionId == element.promotionId)
            .forEach((element2) {
          temp.add(element2);
        });
      }
      if (userServicesHistory != null) {
        userServicesHistory
            .where((element1) => element1.promotionId == element.promotionId)
            .forEach((element2) {
          temp.add(element2);
        });
      }
    }
    temp.forEach((element) {
      response.removeWhere(
          (element1) => element1.promotionId == element.promotionId);
    });
    setState(() {
      isDataLoaded = true;
      if (response != null) {
        promotions = response;
        _isOpen = List.filled(response.length, false, growable: true);
      }
    });
  }
}
