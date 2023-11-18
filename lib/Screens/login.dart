// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:to_do_app/Screens/SignInScreen.dart';
import 'package:to_do_app/Screens/postscreen.dart';
import 'package:to_do_app/utils/toast.dart';
import 'package:to_do_app/widgets/reusablebutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final Passwordcontroller = TextEditingController();
  ValueNotifier<bool> toggle = ValueNotifier<bool>(false);
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    emailcontroller.dispose();
    Passwordcontroller.dispose();
    super.dispose();
  }

  void Login() {
    _auth
        .signInWithEmailAndPassword(
            email: emailcontroller.text, password: Passwordcontroller.text)
        .then((value) {
      utils().tostmessage(value.user!.email.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return PostScreen();
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Login",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, letterSpacing: 2),
          ),
          centerTitle: true,
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
                    width: 250,
                    height: 200,
                    'assets/images/Mobile login-bro.png'),
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
                            keyboardType: TextInputType.visiblePassword,
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
                  neeanimation: false,
                  pading: 96,
                  Title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      Login();
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dont have an account ',
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
                            return SignINScreen();
                          },
                        ));
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffff725e),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
