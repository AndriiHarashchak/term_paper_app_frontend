import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/payment_model.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

class UserPaymentsPage extends StatefulWidget {
  final int userId;
  UserPaymentsPage({Key key, @required this.userId}) : super(key: key);
  @override
  _UserPaymentsPageState createState() => _UserPaymentsPageState();
}

class _UserPaymentsPageState extends State<UserPaymentsPage> {
  bool isDataLoaded;
  List<PaymentModel> userPayments;
  @override
  void initState() {
    isDataLoaded = false;
    super.initState();
    loadData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Історія використання коштів"),
      ),
      body: isDataLoaded == true
          ? () {
              if (userPayments != null && userPayments.length > 0)
                return ListView.builder(
                    itemCount: userPayments.length * 2,
                    itemBuilder: (context, index) =>
                        getListTile(context, index));
              else
                return Center(
                  child: Text("Даних немає"),
                );
            }()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget getListTile(BuildContext context, int index) {
    if (index.isOdd) {
      return Divider();
    }
    int i = index ~/ 2;
    PaymentModel payment = userPayments[i];
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Expanded(flex: 1, child: Text(getTime(payment.paymentDateAndTime))),
            Expanded(flex: 2, child: Text(payment.description)),
            Expanded(flex: 1, child: Text(payment.rate.toString() + " грн")),
          ],
        ),
      ),
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

  void loadData(int userId) async {
    var response = await UserDataProvider().getUserPaymentsHistory(userId);

    setState(() {
      isDataLoaded = true;
      if (response != null) {
        userPayments = response;
        userPayments.sort(
            (a, b) => b.paymentDateAndTime.compareTo(a.paymentDateAndTime));
      }
    });
  }
}
