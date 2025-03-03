import 'package:flutter/material.dart';
import 'package:flutter_application_1/network.dart';
import 'package:flutter_application_1/pages/placeholder.dart';
import 'package:flutter_application_1/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/homepage.dart';

late MyAppState appState;
SharedPreferences? prefs;
late final Account account;

void main() async {
  firebaseInit();

  prefs = await SharedPreferences.getInstance();
  account = createAccount();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Map<String, (ThemeMode, ThemeData)> appThemeMap;
  (ThemeMode, ThemeData) themeData = (ThemeMode.light, ThemeData.light());
  
  String selectedTheme = 'Light';
  bool isLoggedIn = true;

  MyAppState() {
    appThemeMap = {
      "light": (ThemeMode.light, ThemeData(
        primarySwatch: Colors.blue,
        secondaryHeaderColor: Colors.blueAccent,
        cardTheme: getCardTheme(),
        inputDecorationTheme: getInputDecorationTheme(Colors.grey[100]),
        elevatedButtonTheme: getElevatedButtonTheme(Colors.blue, Colors.white),
        appBarTheme: getAppBarTheme(Colors.white, Colors.black)
      )),
      "dark": (ThemeMode.dark, ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        cardTheme: getCardTheme(),
        inputDecorationTheme: getInputDecorationTheme(Colors.grey[800]),
        elevatedButtonTheme: getElevatedButtonTheme(Colors.blueGrey, Colors.white),
        appBarTheme: getAppBarTheme(Colors.black, Colors.white)
      )),
      "pink": (ThemeMode.light, ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Color(0xFFFEE5EC),
        cardTheme: getCardTheme(),
        inputDecorationTheme: getInputDecorationTheme(Color.fromARGB(255, 255, 244, 252)),
        elevatedButtonTheme: getElevatedButtonTheme(Colors.pink, Colors.white),
        appBarTheme: getAppBarTheme(Colors.pink, Colors.white),
        colorScheme: ColorScheme.light(
          primary: Colors.pink,
          secondary: Colors.white,
        ),
      )),
      "ytss": (ThemeMode.light, ThemeData(
        primaryColor: Color(0xFF0A1958), // Navy blue
        scaffoldBackgroundColor: Colors.white,
        cardTheme: getCardTheme(),
        inputDecorationTheme: getInputDecorationTheme(Colors.grey[100]),
        elevatedButtonTheme: getElevatedButtonTheme(Color(0xFF0A1958), Color(0xFFFFC700)),
        appBarTheme: getAppBarTheme(Color(0xFF0A1958), Color(0xFFFFC700)),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF0A1958),
          secondary: Color(0xFFFFC700),
        ),
      ))
    };
    selectedTheme = prefs?.getString('theme') ?? 'light';
    themeData = appThemeMap[selectedTheme] ?? (ThemeMode.light, ThemeData.light());

    appState = this;
  }

  void updateTheme() {
    setState(() {
      themeData = appThemeMap[selectedTheme] ?? (ThemeMode.light, ThemeData.light());
    });
  }

  ElevatedButtonThemeData getElevatedButtonTheme(bgColor, fgColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  AppBarTheme getAppBarTheme(bgColor, fgColor) {
    return AppBarTheme(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      centerTitle: true,
      elevation: 0
    );
  }

  InputDecorationTheme getInputDecorationTheme(fillColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: fillColor,
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
      
      theme: themeData.$2,
      darkTheme: appThemeMap["dark"]?.$2 ?? ThemeData.dark(),
      themeMode: themeData.$1, //custom theme mode
      home: HomePage(),
    );
  }
}

void appSaveToPref() async {
  await prefs?.setString('theme', appState.selectedTheme);
}

Future<void> changeAppTheme(String value, Widget widget, State state) async {
  appState.selectedTheme = value;
  
  state.setState(() {
    appState.updateTheme();
  });
}