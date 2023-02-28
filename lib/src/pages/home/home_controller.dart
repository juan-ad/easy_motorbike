import 'package:easy_motorbike/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class HomeController {
  
  BuildContext? context;
  SharedPref? _sharedPref;

  Future? init(BuildContext context){ 
    this.context = context;
    _sharedPref = SharedPref();
    return null;
  }

  void goToLoginPage(String typeUser) {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context!, 'login');
  }

  void saveTypeUser(String typeUser) async{  
    _sharedPref!.save('typeUser', typeUser);
  }
}