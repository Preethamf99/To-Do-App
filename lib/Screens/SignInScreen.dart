// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/login.dart';
import 'package:to_do_app/on%20boarding%20screens/OnBoardingScreen.dart';
import 'package:to_do_app/utils/toast.dart';
import 'package:to_do_app/widgets/reusablebutton.dart';

class SignINScreen extends StatefulWidget {
  const SignINScreen({super.key});

  @override
  State<SignINScreen> createState() => _SignINScreenState();
}

class _SignINScreenState extends State<SignINScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  final emailcontroller = TextEditingController();
  final Passwordcontroller = TextEditingController();
  ValueNotifier<bool> toggle = ValueNotifier<bool>(false);
  FirebaseAuth _auth = FirebaseAuth.instance;
  void signup() {
    _auth
        .createUserWithEmailAndPassword(
            email: emailcontroller.text.toString(),
            password: Passwordcontroller.text.toString())
        .then((value) {
      utils().tostmessage(
          'User :' + value.user!.email.toString() + '  Registered');
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return OnBoardingScreen();
        },
      ));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      utils().tostmessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailcontroller.dispose();
    Passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    width: 250, height: 200, 'assets/images/Sign in-pana.png'),
                SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Email';
                            } else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ValueListenableBuilder(
                          valueListenable: toggle,
                          builder: (context, value, child) => TextFormField(
                            keyboardType: TextInputType.text,
                            controller: Passwordcontroller,
                            obscureText: toggle.value,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Password',
                                suffixIcon: InkWell(
                                    onTap: () {
                                      toggle.value = !toggle.value;
                                    },
                                    child: Icon(toggle.value
                                        ? Icons.visibility_off
                                        : Icons.visibility)),
                                prefixIcon: Icon(Icons.lock)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Password';
                              } else
                                return null;
                            },
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 50,
                ),
                ReusableBTN(
                  pading: 96,
                  Title: 'Sign Up',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      signup();
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ));
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffff725e),
                            fontWeight: FontWeight.w800),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
