import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:term_paper_app_frontend/Models/user_call_model.dart';
import 'package:term_paper_app_frontend/providers/UserDataProvider.dart';

class UserCallsPage extends StatefulWidget {
  final int userId;
  UserCallsPage({@required this.userId});
  @override
  _UserCallsPageState createState() => _UserCallsPageState();
}

class _UserCallsPageState extends State<UserCallsPage> {
  bool isLoaded = false;
  List<CallModel> userCalls;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    super.initState();
    loadData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Історія дзвінків"),
      ),
      body: isLoaded == true
          ? () {
              if (userCalls != null && userCalls.length > 0)
                return ListView.builder(
                    itemCount: userCalls.length * 2,
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
    CallModel call = userCalls[i];
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(call.callTypeName),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "кому: ${call.interlocutorPhoneNumber.toString()} : ${call.duration.toString()} c."),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Час дзвінка:" + getTime(call.callDateTime)),
                    ),
                  ],
                )),
            //Text(call.callTypeName),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(call.callPrice.toString() + "грн"),
          ),
        ),
      ],
    );
    /* ListTile(
      leading: Text(call.callTypeName),
      title: Text(call.interlocutorPhoneNumber.toString() +
          " " +
          call.duration.toString() +
          "c"),
      trailing: Text(call.callPrice.toString()),
      subtitle: Text(call.callDateTime),
    ); */
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
    var response = await UserDataProvider().getUserCallsHistory(userId);

    setState(() {
      isLoaded = true;
      if (response != null) {
        userCalls = response;
        userCalls.sort((a, b) => b.callDateTime.compareTo(a.callDateTime));
      }
    });
  }
}
