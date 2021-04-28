import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:term_paper_app_frontend/Models/promotion_model.dart';
import 'package:term_paper_app_frontend/pages/promotion_create_page.dart';
import 'package:term_paper_app_frontend/pages/service_create_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class PromotionsPage extends StatefulWidget {
  @override
  _PromotionsPageState createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  List<PromotionModel> activePromotions;
  List<PromotionModel> promotionsHistory;

  bool isdataLoaded;
  GeneralDataProvider _provider;
  List<Tab> _tabsList = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    isdataLoaded = false;
    _provider = new GeneralDataProvider();
    _tabsList.add(Tab(text: "Активні"));
    _tabsList.add(Tab(text: "Історія"));
    loadData();
  }

  TabBar get _tabBar => TabBar(
        tabs: _tabsList,
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
        length: _tabsList.length,
        child: Scaffold(
            appBar: new AppBar(
              title: Text("Акції"),
              bottom: PreferredSize(
                preferredSize: _tabBar.preferredSize,
                child: ColoredBox(
                  color: Colors.white,
                  child: _tabBar,
                ),
              ),
            ),
            body: TabBarView(
              children: _tabsList.map((e) {
                return _getPage(e);
              }).toList(),
            ),
            bottomNavigationBar: BottomAppBar(
              //color: Colors.transparent,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ElevatedButton(
                    child: Text("Створити акцію"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PromotionRegisterPage(
                                type: OperationType.create,
                              )));
                    },
                  ),
                ),
              ),
            )));
  }

  Future<void> loadData() async {
    var active = await _provider.getPromotions();
    var history = await _provider.getPromotionsHistory();

    setState(() {
      if (active != null) activePromotions = active;
      if (history != null) promotionsHistory = history;
      isdataLoaded = true;
    });
  }

  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case "Активні":
        {
          return getServicesInfo(activePromotions, true);
        }
        break;
      case "Історія":
        {
          return getServicesInfo(promotionsHistory, false);
        }
        break;
    }
    return Container();
  }

  Widget getServicesInfo(List<PromotionModel> promotions, bool isActive) {
    if (!isdataLoaded)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (promotions != null && promotions.isNotEmpty)
      return RefreshIndicator(
          key: isActive == true ? _refreshIndicatorKey : _refreshIndicatorKey1,
          child: ListView.builder(
              itemCount: promotions.length * 2,
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();

                int index = i ~/ 2;
                PromotionModel promotion = promotions[index];
                return ExpansionTile(
                  title: Text(promotion.promotionName),
                  children: <Widget>[
                    Column(
                      children: [
                        Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text("Опис:")),
                              Expanded(
                                  flex: 3, child: Text(promotion.description)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text("Умови:")),
                              Expanded(
                                  flex: 3, child: Text(promotion.conditions)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2, child: Text("Термін дії (дні):")),
                              Expanded(
                                  flex: 3,
                                  child:
                                      Text(promotion.activePeriod.toString())),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text("Дата створення:")),
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                      getTime(promotion.registrationDate))),
                            ],
                          ),
                        ),
                        Divider(),
                        () {
                          if (isActive) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 1.0),
                                    child: ElevatedButton(
                                      child: Text("Редагувати акцію"),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PromotionRegisterPage(
                                                      type:
                                                          OperationType.update,
                                                      promotion: promotion,
                                                    )));
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 1.0),
                                    child: TextButton(
                                      child: Text("Деактивувати акцію"),
                                      onPressed: () async {
                                        bool ok =
                                            await _provider.deactivatePromotion(
                                                promotion.promotionId);
                                        if (ok) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  content: Text(
                                                      "Успішно деактивовано")));
                                          loadData();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  content: Text(
                                                      "Не вдалось деактивувати")));
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: TextButton(
                                  child: Text("Активувати акцію"),
                                  onPressed: () {},
                                ),
                              ),
                            );
                          }
                        }(),
                      ],
                    )
                  ],
                );
              }),
          onRefresh: loadData);
    return Center(
      child: Text("Немає акцій"),
    );
  }

  String getTime(String time) {
    int idx = time.indexOf('T');
    List<String> parts = [
      time.substring(0, idx).trim(),
      time.substring(idx + 1).trim()
    ];
    int index2 = parts[1].indexOf(".");
    String time2 = parts[1].substring(0, index2).trim();
    String result = parts[0] + " " + time2;
    return result;
  }
}
