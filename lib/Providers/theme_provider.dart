import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = ThemeData.light();

  ThemeData dark = ThemeData.dark().copyWith(
    // primaryColor: Color.fromRGBO(62, 180, 137, 1),
    primaryColor: const Color.fromRGBO(200, 55, 55, 1),
    //primaryColor: Colors.lightGreenAccent,
    //primaryColor: Color.fromRGBO(241, 87, 72, 1),
    //primaryColor: Color.fromRGBO(66, 251, 16, 1),
    secondaryHeaderColor: Colors.green,
    accentColor: Colors.white,
    errorColor: Colors.black,
    backgroundColor: const Color.fromRGBO(44, 46, 52, 1),
    focusColor: Colors.blueGrey[900],
    appBarTheme: const AppBarTheme(
        color: Colors.black12
    ),
    cardTheme: const CardTheme(
      shadowColor: Colors.transparent,
      color: Colors.black45,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline2: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.lineThrough,
      ),
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
      headline5: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      headline6: TextStyle(
        color: Colors.grey,
        fontSize: 15,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
      subtitle2: TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    ),
  );

  ThemeData light = ThemeData.light().copyWith(
    // primaryColor: Color.fromRGBO(62, 180, 137, 1),
    primaryColor: const Color.fromRGBO(200, 55, 55, 1),
    //primaryColor: Colors.lightGreenAccent,
    //primaryColor: Color.fromRGBO(241, 87, 72, 1),
    //primaryColor: Color.fromRGBO(66, 251, 16, 1),
    secondaryHeaderColor: Colors.green,
    appBarTheme: const AppBarTheme(
      color: Colors.white
    ),
    focusColor: Colors.white24,
    errorColor: Colors.white,
    backgroundColor: Colors.white,
    accentColor: Colors.black87,
    cardTheme: CardTheme(
      color: Colors.grey[300],
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline2: TextStyle(//homePage category accent
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      headline3: TextStyle(
        color: Color.fromRGBO(32, 33, 40, 1),
        fontSize: 15,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.lineThrough,
      ),
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
      headline6: TextStyle(
        color: Colors.grey,
        fontSize: 15,
      ),
      subtitle1: TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
      subtitle2: TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),

    ),
  );

  ThemeProvider(bool darkThemeOn) {
    _selectedTheme = darkThemeOn ? dark : light;
  }

  Future<void> swapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      await prefs.setBool("darkTheme", false);
    }
    else {
      _selectedTheme = dark;
      await prefs.setBool("darkTheme", true);
    }
    notifyListeners();
  }
  ThemeData getTheme() => _selectedTheme;
}