import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:term_paper_app_frontend/Models/service_model.dart';
import 'package:term_paper_app_frontend/pages/service_create_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  List<ServiceModel> activeServices;
  List<ServiceModel> servicesHistory;

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
              title: Text("Послуги"),
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
                    child: Text("Створити послугу"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ServiceRegistrationPage(
                                type: OperationType.create,
                              )));
                    },
                  ),
                ),
              ),
            )));
  }

  Future<void> loadData() async {
    var active = await _provider.getServices();
    var history = await _provider.getServicesHistory();

    setState(() {
      if (active != null) activeServices = active;
      if (history != null) servicesHistory = history;
      isdataLoaded = true;
    });
  }

  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case "Активні":
        {
          return getServicesInfo(activeServices, true);
        }
        break;
      case "Історія":
        {
          return getServicesInfo(servicesHistory, false);
        }
        break;
    }
    return Container();
  }

  Widget getServicesInfo(List<ServiceModel> services, bool isActive) {
    if (!isdataLoaded)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (services != null && services.isNotEmpty)
      return RefreshIndicator(
          key: isActive == true ? _refreshIndicatorKey : _refreshIndicatorKey1,
          child: ListView.builder(
              itemCount: services.length * 2,
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();

                int index = i ~/ 2;
                ServiceModel service = services[index];
                return ExpansionTile(
                  title: Text(service.serviceName),
                  children: <Widget>[
                    Column(
                      children: [
                        Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text("Умови:")),
                              Expanded(
                                  flex: 3, child: Text(service.conditions)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text("Ціна")),
                              Expanded(
                                  flex: 3,
                                  child:
                                      Text(service.price.toString() + " uan")),
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
                                  child: Text(service.activePeriod.toString())),
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
                                  child:
                                      Text(getTime(service.registrationDate))),
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
                                      child: Text("Редагувати послугу"),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    ServiceRegistrationPage(
                                                        service: service,
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
                                      child: Text("Деактивувати послугу"),
                                      onPressed: () async {
                                        bool ok =
                                            await _provider.deactivateService(
                                                service.serviceId);
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
                                  child: Text("Активувати послугу"),
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
      child: Text("Немає послуг"),
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
