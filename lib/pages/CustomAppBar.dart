import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final String title;
  final String employeeName;
  final bool isLoggedIn;
  String _value = "one";
  CustomAppBar(
      {Key key,
      @required this.appBar,
      this.title,
      this.employeeName,
      this.isLoggedIn})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Сторінка працівника"),
      actions: [
        _getActionButton(),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  Widget _getActionButton() {
    if (!isLoggedIn) {
      return Column(
        children: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () => {},
          ),
          //Text("Login"),
        ],
      );
    }
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.face),
          onPressed: () => {},
        ),
        //Text(employeeName),
      ],
    );
  }
}
