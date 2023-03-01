import 'package:easy_motorbike/src/models/client.dart';
import 'package:easy_motorbike/src/models/driver.dart';
import 'package:easy_motorbike/src/providers/auth_provider.dart';
import 'package:easy_motorbike/src/providers/client_provider.dart';
import 'package:easy_motorbike/src/providers/driver_provider.dart';
import 'package:easy_motorbike/src/utils/shared_pref.dart';
import 'package:easy_motorbike/src/utils/snackbar.dart' as utils;
import 'package:flutter/material.dart';

class LoginController{

  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider? _authProvider;
  DriverProvider? _driverProvider;
  ClientProvider? _clientProvider;

  SharedPref? _sharedPref;
  String? _typeUser;

  Future? init(BuildContext context) async{
    this.context = context;
    _authProvider = AuthProvider();
    _driverProvider = DriverProvider();
    _clientProvider = ClientProvider();
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
        if (_typeUser == 'client'){
          Client? client = await _clientProvider!.getById(_authProvider!.getUser()!.uid);
          print("Cliente: $client");
          if (client != null){
            Navigator.pushNamedAndRemoveUntil(context!, 'client/map', (route) => false);
          }else{
            utils.Snackbar.showSnackbar(context, key, 'Usuario No Vàlido');    
            await _authProvider?.singOut();
          }     
        }else if (_typeUser == 'driver'){
          print("Driver");
          Driver? driver = await _driverProvider!.getById(_authProvider!.getUser()!.uid);
          print("Driver: $driver");
          if (driver != null){
            Navigator.pushNamedAndRemoveUntil(context!, 'driver/map', (route) => false);
          }else{
            utils.Snackbar.showSnackbar(context, key, 'Usuario No Válido');    
            await _authProvider?.singOut();
          }
        }
      }else{
        utils.Snackbar.showSnackbar(context, key, 'Usuario No Autenticado');
      }

    } catch(error){
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
    }
    
  }
}