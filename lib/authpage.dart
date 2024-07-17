import 'package:flutterr_app/anasayfa.dart';
import 'package:flutterr_app/loginorsignup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              // user is logged in, navigate to the home page
              return Anasayfa();
            } else {
              return const LoginOrSignUp();
            }
          }
        },
      ),
    );
  }
}
