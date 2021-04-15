import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:term_paper_app_frontend/Models/user_service_model.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

class UserServicesPage extends StatefulWidget {
  final int userId;
  UserServicesPage({Key key, @required this.userId}) : super(key: key);
  @override
  _UserServicesPageState createState() => _UserServicesPageState();
}

class _UserServicesPageState extends State<UserServicesPage>
    with TickerProviderStateMixin {
  List<Tab> tabsList = [];
  //TariffModel currentTariff;
  List<UserServiceModel> _promotionsHistory;
  List<UserServiceModel> _activePromotions;
  bool isDataLoaded = false;
  UserDataProvider _provider;

  List<bool> _historyIsOpen;
  List<bool> _activeIsOpen;
  @override
  void initState() {
    super.initState();
    _provider = UserDataProvider();
    tabsList.add(Tab(text: "Активні"));
    tabsList.add(Tab(text: "Історія"));
    loadData();
  }

  TabBar get _tabBar => TabBar(
        tabs: tabsList,
        labelColor: Colors.red,
        indicator: MD2Indicator(
          indicatorSize: MD2IndicatorSize.full,
          indicatorHeight: 8.0,
          indicatorColor: Colors.red,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabsList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Послуги користувача"),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.white,
              child: _tabBar,
            ),
          ),
        ),
        //drawer: CustomDrawer(),
        body: TabBarView(
          children: tabsList.map((e) {
            return _getPage(e);
          }).toList(),
        ),
        bottomNavigationBar: BottomAppBar(
          //color: Colors.transparent,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: ElevatedButton(
                child: Text("Активувати послугу"),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case "Активні":
        {
          return getActiveServicesInfo();
        }
        break;
      case "Історія":
        {
          return getServicesHistory();
        }
        break;
    }
    return Container();
  }

  Widget getActiveServicesInfo() {
    if (!isDataLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_activePromotions != null)
      return Column(
        children: [
          ExpansionPanelList(
            children: _activePromotions.map<ExpansionPanel>((e) {
              return ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return Text(e.serviceName);
                },
                body: Container(
                  //height: 70,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Дата підключеня: ")),
                          Expanded(
                            flex: 2,
                            child: Text(e.activationDate),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Дата відключення: ")),
                          Expanded(
                            flex: 2,
                            child: Text(e.endDate != null ? e.endDate : ""),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: ElevatedButton(
                            child: Text("Деактивувати"),
                            onPressed: () async {
                              if (await confirm(context,
                                  title: Text("Відключення послуги"),
                                  content: Text(
                                      "Ви впевнені, що хочете деактивувати тариф?"),
                                  textOK: Text("Деактивувати"),
                                  textCancel: Text("Скасувати"))) {
                                bool ok = await _provider.deactivateService(
                                    widget.userId, e.serviceId);
                                if (ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Успішно деактивовано")));
                                  loadData();
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Не вдалось деактивувати")));
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isExpanded: _activeIsOpen[_activePromotions.indexOf(e)],
              );
            }).toList(),
            expansionCallback: (i, isOpen) =>
                setState(() => _activeIsOpen[i] = !isOpen),
          )
        ],
      );
    return Center(
      child: Text("Даних немає"),
    );
  }

  Widget getServicesHistory() {
    if (!isDataLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_promotionsHistory != null)
      return Column(
        children: [
          ExpansionPanelList(
            children: _promotionsHistory.map<ExpansionPanel>((e) {
              return ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return Text(e.serviceName != null
                      ? e.serviceName
                      : "No decriprion for this promotion");
                },
                body: Container(
                  height: 50,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Дата підключеня: ")),
                          Expanded(
                            flex: 2,
                            child: Text(e.activationDate),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Дата відключення: ")),
                          Expanded(
                            flex: 2,
                            child: Text(e.endDate != null ? e.endDate : ""),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isExpanded: _historyIsOpen[_promotionsHistory.indexOf(e)],
              );
            }).toList(),
            expansionCallback: (i, isOpen) =>
                setState(() => _historyIsOpen[i] = !isOpen),
          )
        ],
      );
    return Center(
      child: Text("Даних немає"),
    );
  }

  void loadData() async {
    //Future.delayed(Duration(seconds: 1));
    var activeServices;
    var servicesHistory;
    try {
      activeServices = await _provider.getUserServices(widget.userId);
    } catch (e) {
      print(e.toString());
    }
    try {
      servicesHistory = await _provider.getUserServicesHistory(widget.userId);
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _activePromotions = activeServices;
      if (_activePromotions != null) {
        _activeIsOpen =
            List.filled(_activePromotions.length, false, growable: true);
      }
      _promotionsHistory = servicesHistory;
      if (_promotionsHistory != null)
        _historyIsOpen =
            List.filled(_promotionsHistory.length, false, growable: true);
      isDataLoaded = true;
    });
  }
}
