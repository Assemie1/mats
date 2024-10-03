import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mats/screen/wheel.dart';

void main() {
  runApp(MaterialApp(
    home: RotatingWheel(),
    theme: myTheme,
  ));
}

var myTheme = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(),
        scaffoldBackgroundColor: Color.fromARGB(255, 36, 44, 59),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 102, 85, 143)),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ));


//Color.fromARGB(255, 102, 85, 143),