import 'package:flutter/material.dart';
import 'pages/homepage.dart';

late MyAppState appState;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light; //TODO: file-saving the theme.
  ThemeData? customTheme;
  
  bool isLoggedIn = false;

  MyAppState() {
    appState = this;
  }

  void updateTheme(ThemeMode mode, {ThemeData? custom}) {
    setState(() {
      themeMode = mode;
      customTheme = custom;
    });
  }

  ElevatedButtonThemeData getElevatedButtonTheme(bgColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  AppBarTheme getAppBarTheme() {
    return AppBarTheme(
      centerTitle: true,
      elevation: 0
    );
  }

  InputDecorationTheme getInputDecorationTheme(fillColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: Colors.grey[fillColor],
    );
  }

  CardTheme getCardTheme() {
    return CardTheme(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      // Define the light theme
      theme: customTheme ??
          ThemeData(
            primarySwatch: Colors.blue,
            secondaryHeaderColor: Colors.blueAccent,
            cardTheme: getCardTheme(),
            inputDecorationTheme: getInputDecorationTheme(100),
            elevatedButtonTheme: getElevatedButtonTheme(Colors.blue),
            appBarTheme: getAppBarTheme()
          ),

      // Define the dark theme
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        cardTheme: getCardTheme(),
        inputDecorationTheme: getInputDecorationTheme(800),
        elevatedButtonTheme: getElevatedButtonTheme(Colors.blueGrey),
        appBarTheme: getAppBarTheme()
      ),

      // Set the theme mode based on whether a custom theme is provided
      themeMode: customTheme != null ? ThemeMode.light : themeMode,

      home: HomePage(updateTheme: updateTheme),
    );
  }
}