import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:term_paper_app_frontend/Models/region_model.dart';
import 'package:term_paper_app_frontend/pages/region_create_edit_page.dart';
import 'package:term_paper_app_frontend/pages/service_create_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class RegionsPage extends StatefulWidget {
  @override
  _RegionsPageState createState() => _RegionsPageState();
}

class _RegionsPageState extends State<RegionsPage> {
  List<RegionModel> activeRegions;
  List<RegionModel> regionsHistory;

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
              title: Text("Регіони"),
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
                    child: Text("Створити регіон"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegionCreateEditPage(
                                type: OperationType.create,
                              )));
                    },
                  ),
                ),
              ),
            )));
  }

  Future<void> loadData() async {
    var active = await _provider.getRegions();
    var history = await _provider.getRegionsHistory();

    setState(() {
      if (active != null) activeRegions = active;
      if (history != null) regionsHistory = history;
      isdataLoaded = true;
    });
  }

  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case "Активні":
        {
          return getServicesInfo(activeRegions, true);
        }
        break;
      case "Історія":
        {
          return getServicesInfo(regionsHistory, false);
        }
        break;
    }
    return Container();
  }

  Widget getServicesInfo(List<RegionModel> regions, bool isActive) {
    if (!isdataLoaded)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (regions != null && regions.isNotEmpty)
      return RefreshIndicator(
          key: isActive == true ? _refreshIndicatorKey : _refreshIndicatorKey1,
          child: ListView.builder(
              itemCount: regions.length * 2,
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();

                int index = i ~/ 2;
                RegionModel region = regions[index];
                return ExpansionTile(
                  title: Text(region.regionName),
                  children: <Widget>[
                    Column(
                      children: [
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
                                      child: Text("Редагувати регіон"),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    RegionCreateEditPage(
                                                        region: region,
                                                        type: OperationType
                                                            .update)));
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
                                      child: Text("Деактивувати регіон"),
                                      onPressed: () async {
                                        bool ok = await _provider
                                            .deactivateRegion(region.regionId);
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
                                  child: Text("Активувати регіон"),
                                  onPressed: () {
                                    //TODO implement
                                  },
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
      child: Text("Немає регіонів"),
    );
  }
}
