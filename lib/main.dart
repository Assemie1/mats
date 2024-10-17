import 'package:flutter/material.dart';
import 'package:mats/screen/bookScreen.dart';
import 'package:mats/screen/home.dart';

void main() {
  runApp(MaterialApp(
    home: BookScreen(),
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
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 36, 44, 59),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
      helperStyle: TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Color.fromARGB(255, 102, 85, 143)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 102, 85, 143)),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      dividerColor: Colors.white,
      labelColor: Color.fromARGB(255, 102, 85, 143),
      unselectedLabelColor: Colors.white,
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Color.fromARGB(255, 102, 85, 143)),
      fillColor: MaterialStateProperty.all(Colors.white),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromARGB(255, 102, 85, 143),
      contentTextStyle: TextStyle(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.white)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 102, 85, 143),
        shape: CircleBorder())
);
