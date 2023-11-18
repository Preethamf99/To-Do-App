// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/login.dart';
import 'package:to_do_app/providers/theam.dart';
import 'package:to_do_app/widgets/reusablebutton.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key});

  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

final user = FirebaseAuth.instance.currentUser!;

class _SettingscreenState extends State<Settingscreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final theamchanger = Provider.of<Theamchanger>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            color: theamchanger.containerColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'App Theam',
                    style: TextStyle(
                        fontSize: 24.sp, color: theamchanger.textColor),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Switch(
                    value: theamchanger.isDarkMode,
                    onChanged: (value) {
                      theamchanger.toggleTheme();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Text(
                    'user :',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(
                          0xff263238,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    user.email.toString(),
                    style: TextStyle(color: Color(0xff455A64)),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ReusableBTN(
                      pading: 60.h,
                      Title: 'LogOut',
                      onTap: () {
                        _auth.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
