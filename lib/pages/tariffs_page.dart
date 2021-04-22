import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:term_paper_app_frontend/Models/tariff_model.dart';
import 'package:term_paper_app_frontend/pages/tariff_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class TariffsPage extends StatefulWidget {
  @override
  _TariffsPageState createState() => _TariffsPageState();
}

class _TariffsPageState extends State<TariffsPage> {
  List<TariffModel> activeTariffs;
  List<TariffModel> tariffsHistory;

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
              title: Text("Тарифи"),
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
                    child: Text("Створити тариф"),
                    onPressed: () {
                      /* Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ActivationPage(
                            userId: widget.user.userId,
                            tariffId: widget.user.tariffId,
                            type: Type.service,
                          ))); */
                    },
                  ),
                ),
              ),
            )));
  }

  Future<void> loadData() async {
    var active = await _provider.getTariffs();
    var history = await _provider.getTariffsHistory();

    setState(() {
      if (active != null) activeTariffs = active;
      if (history != null) tariffsHistory = history;
      isdataLoaded = true;
    });
  }

  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case "Активні":
        {
          return getServicesInfo(activeTariffs, true);
        }
        break;
      case "Історія":
        {
          return getServicesInfo(tariffsHistory, false);
        }
        break;
    }
    return Container();
  }

  Widget getServicesInfo(List<TariffModel> tariffs, bool isActive) {
    if (!isdataLoaded)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (tariffs != null && tariffs.isNotEmpty)
      return RefreshIndicator(
          key: isActive == true ? _refreshIndicatorKey : _refreshIndicatorKey1,
          child: ListView.builder(
              itemCount: tariffs.length * 2,
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();

                int index = i ~/ 2;
                TariffModel tariff = tariffs[index];
                return ListTile(
                  title: Text(tariff.tariffName),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => TariffPage(tariff: tariff)),
                    );
                  },
                );
              }),
          onRefresh: loadData);
    return Center(
      child: Text("Немає тарифів"),
    );
  }
}
