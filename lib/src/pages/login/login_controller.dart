import 'package:easy_motorbike/src/providers/auth_provider.dart';
import 'package:easy_motorbike/src/utils/shared_pref.dart';
import 'package:easy_motorbike/src/utils/snackbar.dart' as utils;
import 'package:flutter/material.dart';

class LoginController{

  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider? _authProvider;

  SharedPref? _sharedPref;
  String? _typeUser;

  Future? init(BuildContext context) async{
    this.context = context;
    _authProvider = AuthProvider();
    _sharedPref = SharedPref();
    _typeUser = await _sharedPref?.read('typeUser');
    return null;
  }
  void goToRegisterPage(){
    if (_typeUser == 'client'){
      Navigator.pushNamed(context!, 'client/register');
    }else{
      Navigator.pushNamed(context!, 'driver/register');
    }
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try{
      bool? isLogin = await _authProvider?.login(email, password);

      if (isLogin == true){
        utils.Snackbar.showSnackbar(context, key, 'Usuario Logeado');
      }else{
        utils.Snackbar.showSnackbar(context, key, 'Usuario No Autenticado');
      }

    } catch(error){
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
    }
    
  }
}