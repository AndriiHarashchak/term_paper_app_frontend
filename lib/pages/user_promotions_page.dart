import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:term_paper_app_frontend/Models/user_promotion_model.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

class UserPromotionsPage extends StatefulWidget {
  final int userId;
  UserPromotionsPage({Key key, @required this.userId}) : super(key: key);
  @override
  _UserPromotionsPageState createState() => _UserPromotionsPageState();
}

class _UserPromotionsPageState extends State<UserPromotionsPage>
    with TickerProviderStateMixin {
  List<Tab> tabsList = [];
  //TariffModel currentTariff;
  List<UserPromotionModel> _promotionsHistory;
  List<UserPromotionModel> _activePromotions;
  bool isDataLoaded = false;
  UserDataProvider _provider;

  List<bool> _historyIsOpen;
  List<bool> _activeIsOpen;
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
          return getActivePromotionsInfo();
        }
        break;
      case "History":
        {
          return getPromotionsHistory();
        }
        break;
    }
    return null;
  }

  Widget getActivePromotionsInfo() {
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
                  return Text(e.description);
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

  Widget getPromotionsHistory() {
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
                  return Text(e.description != null
                      ? e.description
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
    var activePromotions;
    var promotionsHistory;
    try {
      activePromotions = await _provider.getUserPromotions(widget.userId);
    } catch (e) {
      print(e.toString());
    }
    try {
      promotionsHistory =
          await _provider.getUserPromotionsHistory(widget.userId);
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _activePromotions = activePromotions;
      if (_activePromotions != null) {
        _activeIsOpen =
            List.filled(_activePromotions.length, false, growable: true);
      }
      _promotionsHistory = promotionsHistory;
      if (_promotionsHistory != null)
        _historyIsOpen =
            List.filled(_promotionsHistory.length, false, growable: true);
      isDataLoaded = true;
    });
  }
}
