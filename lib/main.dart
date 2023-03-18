import 'package:easy_motorbike/src/pages/client/map/client_map_page.dart';
import 'package:easy_motorbike/src/pages/client/travel_info/client_travel_info_page.dart';
import 'package:easy_motorbike/src/pages/driver/map/driver_map_page.dart';
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
        'home': (BuildContext context) => const HomePage(),
        'login': (BuildContext context) => const LoginPage(),
        'client/register': (BuildContext context) => const ClientRegisterPage(),
        'client/map': (BuildContext context) => const ClientMapPage(),
        'driver/register': (BuildContext context) => const DriverRegisterPage(),
        'driver/map': (BuildContext context) => const DriverMapPage(),
        'client/travel/info': (BuildContext context) => const ClientTravelInfoPage(),
      }
    );
  }
}

