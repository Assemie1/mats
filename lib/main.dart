import 'package:flutter/material.dart';
import 'package:mats/screen/home.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: myTheme,
  ));
}

var myTheme = ThemeData(
  useMaterial3: true,

  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 36, 44, 59),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      ),
    ),

  scaffoldBackgroundColor: const Color.fromARGB(255, 36, 44, 59),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color.fromARGB(255, 102, 85, 143)),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    labelStyle: TextStyle(color: Color.fromARGB(255, 102, 85, 143)),
    helperStyle: TextStyle(color: Color.fromARGB(255, 102, 85, 143)),
    hintStyle: TextStyle(color: Color.fromARGB(255, 102, 85, 143)),
  ),
  

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 102, 85, 143)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),
  )

);


//Color.fromARGB(255, 102, 85, 143),