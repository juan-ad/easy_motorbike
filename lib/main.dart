import 'package:easy_motorbike/src/pages/driver/register/driver_register_page.dart';
import 'package:easy_motorbike/src/pages/home/home_page.dart';
import 'package:easy_motorbike/src/pages/login/login_page.dart';
import 'package:easy_motorbike/src/pages/client/register/client_register_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_motorbike/src/utils/colors.dart' as utils;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        'client/register': (BuildContext context) => const ClientRegisterPage(),
        'driver/register': (BuildContext context) => const DriverRegisterPage(),
      }
    );
  }
}

