import 'package:easy_motorbike/pages/home/home_page.dart';
import 'package:easy_motorbike/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_motorbike/utils/colors.dart' as utils;

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy MotorBike',
      initialRoute: 'home',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        appBarTheme: const AppBarTheme( 
          elevation: 0
        ),
        primaryColor: utils.Colors.easyMotoColor
      ),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => const LoginPage(),
      }
    );
  }
}

