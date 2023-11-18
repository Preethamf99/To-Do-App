// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Theamchanger with ChangeNotifier {
  ThemeData _theamMode = ThemeData.light();

  Theamchanger() {
    loadTheme();
  }
  Color get textColor => _theamMode.brightness == Brightness.dark
      ? Colors.black
      : Color(0xffff725e);
  Color? get containerColor => _theamMode.brightness == Brightness.dark
      ? Color(0xffff725e)
      : Colors.grey[300];

  Color? get scaffoldcolr => _theamMode.brightness == Brightness.dark
      ? Color(0xffff725e)
      : Colors.white70;
  Color? get btncolro => _theamMode.brightness == Brightness.dark
      ? Colors.grey[300]
      : Colors.black87;
  ThemeData get themeModes => _theamMode;

  bool get isDarkMode => _theamMode.brightness == Brightness.dark;

  void toggleTheme() {
    _theamMode = isDarkMode ? ThemeData.light() : ThemeData.dark();
    saveTheme();
    notifyListeners();
  }

  void saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _theamMode == ThemeData.dark());
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _theamMode = isDarkTheme ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
