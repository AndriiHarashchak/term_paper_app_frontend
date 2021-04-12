import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/pages/CustomAppBar.dart';
import 'package:term_paper_app_frontend/pages/employee_page.dart';
import 'package:term_paper_app_frontend/providers/EmployeeDataReceiver.dart';
import 'package:flutter_session/flutter_session.dart';

class LoginScreen extends StatelessWidget {
  //final Function(String, dynamic) onTapped;
  //LoginScreen({@required this.onTapped});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Вхід в програму")),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: LoginForm(
                //onPressed: onTapped,
                ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  //final Function(String, dynamic) onPressed;
  //LoginForm({@required this.onPressed});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  double _formProgress = 0;
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Login', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(hintText: 'Username'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passwordTextController,
              decoration: InputDecoration(hintText: 'Password'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: _formProgress == 1 ? _login : null,
            child: Text('Login'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(errorMessage),
          ),
        ],
      ),
    );
  }

  _login() async {
    setState(() {
      errorMessage = "";
    });
    if (!_usernameTextController.value.text.isNotEmpty ||
        !_passwordTextController.value.text.isNotEmpty) {
      setState(() {
        errorMessage = "login and password can`t be zero";
      });
      return;
    }
    Employee response = await EmployeeDataProvider().login(
        int.parse(_usernameTextController.text), _passwordTextController.text);
    if (response != null) {
      await FlutterSession().set('employee', response);
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => EmployeePage()));
      //TODO push to employee page
      /*setState(() {
        errorMessage = response["Name"];
      });*/
      //globalVariables.isLoggedIn = true;
      //globalVariables.currentEmployee = Employee.fromJson(response);
      //widget.onPressed(RoutesNames.employee, Employee.fromJson(response));
    } else {
      setState(() {
        errorMessage = "Incorrect login or password! try again";
      });
      //show error message
    }
  }

  /*_showWelcomeScreen(){
    Navigator.of(context).pushNamed('/welcome');
  }*/
  _updateFormProgress() {
    var progress = 0.0;
    final controllers = [_usernameTextController, _passwordTextController];
    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }
    setState(() {
      _formProgress = progress;
    });
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  AnimatedProgressIndicator({
    @required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  Animation<double> _curveAnimation;

  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}
