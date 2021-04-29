import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/user_sms_model.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';
import 'package:term_paper_app_frontend/providers/data_mapper.dart';

class UserSmsPage extends StatefulWidget {
  final int userId;
  UserSmsPage({@required this.userId});
  @override
  _UserSmsPageState createState() => _UserSmsPageState();
}

class _UserSmsPageState extends State<UserSmsPage> {
  bool isLoaded = false;
  List<SmsModel> userSms;
  @override
  void initState() {
    super.initState();
    loadData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Історія повідомлень"),
      ),
      body: isLoaded == true
          ? () {
              if (userSms != null && userSms.length > 0)
                return ListView.builder(
                    itemCount: userSms.length * 2,
                    itemBuilder: (context, index) =>
                        getCustomListTile(context, index));
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

  Widget getCustomListTile(BuildContext context, int index) {
    if (index.isOdd) return Divider();

    int i = index ~/ 2;
    SmsModel sms = userSms[i];
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(sms.smsTypeName)],
      ),
      title: Text("Абонент: " + sms.receiverPhoneNumber.toString()),
      trailing: Text(sms.price.toString() + " грн."),
      subtitle: Text(DataModifier.getTimeAndDate(sms.timeSent)),
    );
  }

  void loadData(int userId) async {
    var response = await UserDataProvider().getUserSmsHistory(userId);

    setState(() {
      isLoaded = true;
      if (response != null) {
        userSms = response;
        userSms.sort((a, b) => b.timeSent.compareTo(a.timeSent));
      }
    });
  }
}
