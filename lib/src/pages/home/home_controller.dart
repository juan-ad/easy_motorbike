import 'package:easy_motorbike/src/providers/auth_provider.dart';
import 'package:easy_motorbike/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class HomeController {
  
  BuildContext? context;
  SharedPref? _sharedPref;

  AuthProvider? _authProvider;
  String? _typeUser;

  Future? init(BuildContext context) async{ 
    this.context = context;
    _sharedPref = SharedPref();
    _authProvider = AuthProvider();

    _typeUser = await _sharedPref?.read('typeUser');
    checkIfUserIsAuth();
    return null;
  }

  void checkIfUserIsAuth() {
    bool isSigned = _authProvider!.isSignedIn();
    
    if (isSigned){
      if (_typeUser == 'client'){
        Navigator.pushNamedAndRemoveUntil(context!, 'client/map', (route) => false);
      }else{
        Navigator.pushNamedAndRemoveUntil(context!, 'driver/map', (route) => false);
      }
      
    }
  }

  void goToLoginPage(String typeUser) {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context!, 'login');
  }

  void saveTypeUser(String typeUser) async{  
    _sharedPref!.save('typeUser', typeUser);
  }
}