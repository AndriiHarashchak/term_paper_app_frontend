import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:term_paper_app_frontend/Models/userModel.dart';
import 'package:term_paper_app_frontend/Models/user_service_model.dart';
import 'package:term_paper_app_frontend/pages/activation_page.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

class UserServicesPage extends StatefulWidget {
  final UserModel user;
  UserServicesPage({Key key, @required this.user}) : super(key: key);
  @override
  _UserServicesPageState createState() => _UserServicesPageState();
}

class _UserServicesPageState extends State<UserServicesPage>
    with TickerProviderStateMixin {
  List<Tab> tabsList = [];
  //TariffModel currentTariff;
  List<UserServiceModel> _servicesHistory;
  List<UserServiceModel> _activeServices;
  bool isDataLoaded = false;
  UserDataProvider _provider;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
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
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ActivationPage(
                            userId: widget.user.userId,
                            tariffId: widget.user.tariffId,
                            type: Type.service,
                          )));
                },
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
          return getServicesData(_activeServices, true);
        }
        break;
      case "Історія":
        {
          return getServicesData(_servicesHistory, false);
        }
        break;
    }
    return Container();
  }

  Widget getServicesData(List<UserServiceModel> services, bool isActive) {
    if (!isDataLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (services != null)
      return ListView.builder(
        itemCount: services.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          int index = i ~/ 2;
          return ExpansionTile(
            title: Text(services[index].serviceName != null
                ? services[index].serviceName
                : "Без імені"),
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: Text("Дата підключеня: "),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(formatter.format(
                              DateTime.parse(services[index].activationDate))),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: Text("Дата відключення: "),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(services[index].endDate != null
                              ? formatter.format(
                                  formatter.parse(services[index].endDate))
                              : ""),
                        ),
                      ],
                    ),
                    () {
                      if (isActive) {
                        return SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: ElevatedButton(
                              child: Text("Деактивувати"),
                              onPressed: () async {
                                if (await confirm(context,
                                    title: Text("Деактивація послуги"),
                                    content: Text(
                                        "Ви впевнені, що хочете деактивувати послугу?"),
                                    textOK: Text("Деактивувати"),
                                    textCancel: Text("Скасувати"))) {
                                  bool ok = await _provider.deactivateService(
                                      widget.user.userId,
                                      services[index].serviceId);
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
                        );
                      }
                      return Container();
                    }()
                  ],
                ),
              ),
            ],
          );
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
      );
    return RefreshIndicator(
      onRefresh: loadData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Text('Активних послуг немає'),
          ),
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }

  Future<void> loadData() async {
    //Future.delayed(Duration(seconds: 1));
    var activeServices;
    var servicesHistory;
    try {
      activeServices = await _provider.getUserServices(widget.user.userId);
    } catch (e) {
      print(e.toString());
    }
    try {
      servicesHistory =
          await _provider.getUserServicesHistory(widget.user.userId);
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isDataLoaded = true;
      _activeServices = activeServices;
      _servicesHistory = servicesHistory;
    });
  }
}
