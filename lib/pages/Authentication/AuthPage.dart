import 'package:flutter/material.dart';
import 'package:mental_health_app/main.dart';
import 'package:mental_health_app/pages/Authentication/signUp.dart';

import 'login.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? Login(onClickSignUp: toggle)
      : SignUp(onClickSignIn: toggle);
  void toggle() => setState(() {
    isLogin = !isLogin;
  });
}
