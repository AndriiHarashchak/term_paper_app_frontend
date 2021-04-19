import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:term_paper_app_frontend/Models/office_model.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class OfficesPage extends StatefulWidget {
  @override
  _OfficesPageState createState() => _OfficesPageState();
}

class _OfficesPageState extends State<OfficesPage> {
  List<OfficeModel> activeOffices;
  List<OfficeModel> officesHistory;

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
    _tabsList.add(Tab(text: "Працюючі"));
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
              title: Text("Офіси"),
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
                    child: Text("Зареєструвати офіс"),
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
    var offices = await _provider.getOffices();
    //var history = await _provider.getServicesHistory();

    setState(() {
      if (offices != null) {
        activeOffices =
            offices.where((element) => element.isWorking == true).toList();
        officesHistory =
            offices.where((element) => element.isWorking == false).toList();
      }
      isdataLoaded = true;
    });
  }

  Widget _getPage(Tab tab) {
    switch (tab.text) {
      case "Працюючі":
        {
          return getOfficesInfo(activeOffices, true);
        }
        break;
      case "Історія":
        {
          return getOfficesInfo(officesHistory, false);
        }
        break;
    }
    return Container();
  }

  Widget getOfficesInfo(List<OfficeModel> offices, bool isActive) {
    if (!isdataLoaded)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (offices != null && offices.isNotEmpty)
      return RefreshIndicator(
          key: isActive == true ? _refreshIndicatorKey : _refreshIndicatorKey1,
          child: ListView.builder(
              itemCount: offices.length * 2,
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();

                int index = i ~/ 2;
                OfficeModel office = offices[index];
                return ExpansionTile(
                  title: Text("Office " + office.officeId.toString()),
                  children: <Widget>[
                    Column(
                      children: [
                        Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text("Адреса:")),
                              Expanded(flex: 3, child: Text(office.adress)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2, child: Text("Дата відкриття: ")),
                              Expanded(flex: 3, child: Text(office.openedAt)),
                            ],
                          ),
                        ),
                        if (!office.isWorking)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2, child: Text("Дата закритття:")),
                                Expanded(
                                    flex: 3,
                                    child: Text(office.closingDate ?? "")),
                              ],
                            ),
                          ),
                        Divider(),
                        () {
                          if (isActive) {
                            return SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 1.0),
                                child: TextButton(
                                  child: Text("Видалити офіс з доступних"),
                                  onPressed: () async {
                                    bool ok = await _provider
                                        .deactivateOffice(office.officeId);
                                    if (ok) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content:
                                                  Text("Успішно видалено")));
                                      loadData();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content:
                                                  Text("Не вдалось видалили")));
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                          return Container();
                        }(),
                      ],
                    )
                  ],
                );
              }),
          onRefresh: loadData);
    return Center(
      child: Text("Немає офісів"),
    );
  }
}
