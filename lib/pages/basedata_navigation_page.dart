import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/pages/custom_app_drawer.dart';
import 'package:term_paper_app_frontend/pages/promotions_page.dart';
import 'package:term_paper_app_frontend/pages/regions_page.dart';
import 'package:term_paper_app_frontend/pages/services_page.dart';
import 'package:term_paper_app_frontend/pages/tariffs_page.dart';

class BasedataNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Тарифи та послуги"),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                child: Text("Тарифи"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TariffsPage()),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                child: Text("Послуги"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ServicesPage()),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                child: Text("Акції"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PromotionsPage()),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                child: Text("Регіони"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegionsPage()),
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
