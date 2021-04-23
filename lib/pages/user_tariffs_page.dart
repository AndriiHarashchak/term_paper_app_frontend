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
  TextStyle textStyle;
  @override
  void initState() {
    super.initState();
    textStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
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
      return SingleChildScrollView(
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
                          currentTariff.tariffName.toString(),
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
                          currentTariff.minutesWithinTheOperator.toString(),
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
                          currentTariff.minutesToOtherOperators.toString(),
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
                          currentTariff.smsCount.toString(),
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
                          currentTariff.internetTrafficSize.toString(),
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
                          currentTariff.callPrice.toString() ?? "",
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
                          currentTariff.smsPrice.toString() ?? "",
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
                          currentTariff.pricePerPeriod != null
                              ? currentTariff.pricePerPeriod.toString()
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
                          currentTariff.regionRef.toString(),
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
                          currentTariff.isActive == true
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
                    Expanded(flex: 4, child: Text("Дата активації:")),
                    Expanded(
                        flex: 4,
                        child: Text(
                          currentTariff.activationDate ?? "",
                          style: textStyle,
                        ))
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
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
      return ListView.builder(
          itemCount: tariffsHistory.length * 2,
          itemBuilder: (context, index) {
            if (index.isOdd) return Divider();
            int i = index ~/ 2;
            var tariff = tariffsHistory[i];
            return ExpansionTile(
              title: Text(tariff.tariffName),
              children: [
                Column(
                  children: [
                    Divider(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text("Дата підключення:")),
                          Expanded(flex: 3, child: Text(tariff.activationDate)),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text("Дата відключення:")),
                          Expanded(
                              flex: 3, child: Text(tariff.deactivationDate)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
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
      isDataLoaded = true;
    });
  }
}
