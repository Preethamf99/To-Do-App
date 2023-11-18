// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:to_do_app/on%20boarding%20screens/SplashServices.dart';

class SplashScreenOpen extends StatefulWidget {
  const SplashScreenOpen({super.key});

  @override
  State<SplashScreenOpen> createState() => _SplashScreenOpenState();
}

class _SplashScreenOpenState extends State<SplashScreenOpen> {
  splashServices splashservices = new splashServices();
  @override
  void initState() {
    // TODO: implement initStat
    super.initState();
    splashservices.islogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'ToDoApp',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    );
  }
}
