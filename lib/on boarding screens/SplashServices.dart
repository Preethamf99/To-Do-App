// ignore_for_file: use_function_type_syntax_for_parameters, non_constant_identifier_names, prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:to_do_app/Screens/login.dart';
import 'package:to_do_app/Screens/postscreen.dart';

class splashServices {
  void islogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return PostScreen();
              })));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginScreen();
              })));
    }
  }
}
