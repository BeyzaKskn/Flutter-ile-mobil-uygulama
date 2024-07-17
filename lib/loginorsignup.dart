import 'package:flutterr_app/loginpage.dart';
import 'package:flutterr_app/signup.dart';
import 'package:flutter/material.dart';

class LoginOrSignUp extends StatefulWidget {
  const LoginOrSignUp({super.key});

  @override
  State<LoginOrSignUp> createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<LoginOrSignUp> {
  bool isLogin = true;

  void togglePage() {
    setState(
      () {
        isLogin = !isLogin;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginPag(
        onPressed: togglePage,
      );
    } else {
      return SignUp(
        onPressed: togglePage,
      );
    }
  }
}
