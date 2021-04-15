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
      height: 50,
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(payment.paymentDateAndTime)),
          Expanded(flex: 2, child: Text(payment.description)),
          Expanded(
              flex: 1,
              child: Text("Сума: " + payment.rate.toString() + " uan")),
        ],
      ),
    );
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
