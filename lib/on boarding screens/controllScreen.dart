import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/login.dart';
import 'package:to_do_app/Screens/postscreen.dart';

class ControllScreen extends StatelessWidget {
  const ControllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user loged in
          if (snapshot.hasData) {
            return PostScreen();
          } else {
            return LoginScreen();
          }
        }, //is user not loged in
      ),
    );
  }
}
