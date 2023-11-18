import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase_options.dart';
import 'package:to_do_app/on%20boarding%20screens/splashOpenScreen.dart';
import 'package:to_do_app/providers/pageprovider.dart';
import 'package:to_do_app/providers/theam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => OnBoardNotifier(),
            ),
            ChangeNotifierProvider(create: (context) => Theamchanger())
          ],
          child: Builder(builder: (context) {
            final theamchanger = Provider.of<Theamchanger>(context);
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: theamchanger.themeModes,
                title: 'Flutter Demo',
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                ),
                home: const SplashScreenOpen());
          })),
    );
  }
}
