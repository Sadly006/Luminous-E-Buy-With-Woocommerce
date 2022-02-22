import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = ThemeData.light();

  ThemeData dark = ThemeData.dark().copyWith(
    // primaryColor: const Color.fromRGBO(255, 95, 31, 1),
    // primaryColor: const Color.fromRGBO(200, 55, 55, 1),
    //primaryColor: Colors.lightGreenAccent,
    //primaryColor: Color.fromRGBO(241, 87, 72, 1),
    primaryColor: Color.fromRGBO(153, 101, 244, 1),
    secondaryHeaderColor: Color.fromRGBO(38, 40, 42, 1),
    // cardColor: const Color.fromRGBO(31, 7, 1, 1),,
    accentColor: Colors.white70,
    errorColor: Colors.black,
    brightness: Brightness.dark,
    //backgroundColor: Colors.redAccent,
    //backgroundColor: const Color.fromRGBO(44, 46, 52, 1),
    backgroundColor: const Color.fromRGBO(38, 40, 42, 1),
    // scaffoldBackgroundColor: const Color.fromRGBO(58, 58, 58, 1),
    scaffoldBackgroundColor: const Color.fromRGBO(13, 3, 1, 1),
    // backgroundColor: const Color.fromRGBO(15, 2, 0, 1),
    focusColor: Colors.blueGrey[900],
    shadowColor: Colors.transparent,
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
        fontSize: 18,
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
    // primaryColor: const Color.fromRGBO(255, 95, 31, 1),
    // primaryColor: const Color.fromRGBO(200, 55, 55, 1),
    //primaryColor: Colors.lightGreenAccent,
    //primaryColor: Color.fromRGBO(241, 87, 72, 1),
    primaryColor: Color.fromRGBO(126, 63, 242, 1),
    secondaryHeaderColor: Color.fromRGBO(126, 63, 242, 1),
    appBarTheme: const AppBarTheme(
      color: Colors.white
    ),
    scaffoldBackgroundColor: Color.fromRGBO(243, 240, 247, 1),
    focusColor: Colors.white24,
    errorColor: Colors.white,
    backgroundColor: Colors.white24,
    accentColor: const Color.fromRGBO(49, 52, 56, 1),
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