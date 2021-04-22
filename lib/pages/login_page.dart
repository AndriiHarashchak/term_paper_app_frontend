import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/pages/employee_page.dart';
import 'package:term_paper_app_frontend/providers/employee_data_provider.dart';
import 'package:flutter_session/flutter_session.dart';

class LoginScreen extends StatelessWidget {
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
          //AnimatedProgressIndicator(value: _formProgress),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text('Вхід в систему',
                style: Theme.of(context).textTheme.headline5),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(hintText: 'Логін'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passwordTextController,
              decoration: InputDecoration(hintText: 'Пароль'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                        : Colors.red;
                  }),
                ),
                onPressed: _formProgress == 1 ? _login : null,
                child: Text('Вхід'),
              ),
            ),
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
        errorMessage = "Поля логіну та паролю не можуть бути пустими";
      });
      return;
    }
    Employee response = await EmployeeDataProvider().login(
        int.parse(_usernameTextController.text), _passwordTextController.text);
    if (response != null) {
      await FlutterSession().set('employee', response);
      //Navigator..pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => EmployeePage()));
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (context) => EmployeePage(
                    employee: response,
                    isLoggedIn: true,
                  )),
          (route) => false);
    } else {
      setState(() {
        errorMessage = "Неправильний логін або пароль! Спробуйте ще раз";
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
