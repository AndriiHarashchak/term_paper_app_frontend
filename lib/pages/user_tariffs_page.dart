import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:term_paper_app_frontend/Models/UserTariffModel.dart';
import 'package:term_paper_app_frontend/Models/tariff_model.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

class UserTariffsPage extends StatefulWidget {
  final int userId;
  UserTariffsPage({Key key, @required this.userId}) : super(key: key);
  @override
  _UserTariffsPageState createState() => _UserTariffsPageState();
}

class _UserTariffsPageState extends State<UserTariffsPage>
    with TickerProviderStateMixin {
  List<Tab> tabsList = [];
  TariffModel currentTariff;
  List<UserTariffModel> tariffsHistory;
  bool isDataLoaded = false;
  UserDataProvider _provider;

  List<bool> _isOpen;

  @override
  void initState() {
    super.initState();
    _provider = UserDataProvider();
    tabsList.add(Tab(text: "Current"));
    tabsList.add(Tab(text: "History"));
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
          title: Text("Тарифи користувача"),
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
      ),
    );
  }

  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case "Current":
        {
          return getCurrentTariffInfo();
        }
        break;
      case "History":
        {
          return getTariffsHisory();
        }
        break;
    }
    return null;
  }

  Widget getCurrentTariffInfo() {
    if (!isDataLoaded)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (currentTariff != null)
      return Column(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: Text("Назва тарифу: ")),
              Expanded(flex: 2, child: Text(currentTariff.tariffName)),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: Text("Хвилин на інші оператори: ")),
              Expanded(
                  flex: 2,
                  child:
                      Text(currentTariff.minutesToOtherOperators.toString())),
            ],
          ),
        ],
      );
    return Center(
      child: Text("Дані не доступні"),
    );
  }

  Widget getTariffsHisory() {
    if (!isDataLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (tariffsHistory != null)
      return Column(
        children: [
          ExpansionPanelList(
            children: tariffsHistory.map<ExpansionPanel>((e) {
              return ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return Text(e.tariffName);
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
                            child: Text(e.deactivationDate != null
                                ? e.deactivationDate
                                : ""),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isExpanded: _isOpen[tariffsHistory.indexOf(e)],
              );
            }).toList(),
            expansionCallback: (i, isOpen) =>
                setState(() => _isOpen[i] = !isOpen),
          )
        ],
      );
    return Center(
      child: Text("Даних немає"),
    );
  }

  void loadData() async {
    var currentTariffData;
    var tariffHistory;
    try {
      currentTariffData = await _provider.getCurrentUserTariff(widget.userId);
    } catch (e) {
      print(e.toString());
    }
    try {
      tariffHistory = await _provider.getUsertariffsHistory(widget.userId);
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      this.currentTariff = currentTariffData;
      tariffsHistory = tariffHistory;
      if (tariffsHistory != null)
        _isOpen = List.filled(tariffsHistory.length, false, growable: true);
      isDataLoaded = true;
    });
  }
}
