import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/userModel.dart';
import 'package:term_paper_app_frontend/pages/custom_app_drawer.dart';
import 'package:term_paper_app_frontend/pages/user_promotions_page.dart';
import 'package:term_paper_app_frontend/pages/user_tariffs_page.dart';

class UserPage extends StatefulWidget {
  final UserModel user;
  //final Function(String, dynamic) ontapped;
  UserPage({Key key, @required this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Інформація про користувача"),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Text(widget.user.userId.toString()),
          Text(widget.user.name),
          Text(widget.user.surname),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      UserTariffsPage(userId: widget.user.userId)))
            },
            //widget.ontapped(RoutesNames.userTariffs, widget.user.userId),
            child: Text("user Tafiffs info"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UserPromotionsPage(userId: widget.user.userId)))
              },
              //widget.ontapped(RoutesNames.userTariffs, widget.user.userId),
              child: Text("user promotions info"),
            ),
          ),
        ],
      ),
    );
  }
}
