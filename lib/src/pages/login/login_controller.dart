import 'package:easy_motorbike/src/models/client.dart';
import 'package:easy_motorbike/src/models/driver.dart';
import 'package:easy_motorbike/src/providers/auth_provider.dart';
import 'package:easy_motorbike/src/providers/client_provider.dart';
import 'package:easy_motorbike/src/providers/driver_provider.dart';
import 'package:easy_motorbike/src/utils/my_progress_dialog.dart';
import 'package:easy_motorbike/src/utils/shared_pref.dart';
import 'package:easy_motorbike/src/utils/snackbar.dart' as utils;
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class LoginController{

  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider? _authProvider;
  DriverProvider? _driverProvider;
  ClientProvider? _clientProvider;
  ProgressDialog? _progressDialog;

  SharedPref? _sharedPref;
  String? _typeUser;

  Future? init(BuildContext context) async{
    this.context = context;
    _authProvider = AuthProvider();
    _driverProvider = DriverProvider();
    _clientProvider = ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
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

    _progressDialog?.show();

    try{
      bool? isLogin = await _authProvider?.login(email, password);

      if (isLogin == true){
        if (_typeUser == 'client'){
          Client? client = await _clientProvider!.getById(_authProvider!.getUser()!.uid);
          
          if (client != null){
            _progressDialog?.hide();
            Navigator.pushNamedAndRemoveUntil(context!, 'client/map', (route) => false);
          }else{
            _progressDialog?.hide();
            utils.Snackbar.showSnackbar(context, key, 'Usuario No Válido');    
            await _authProvider?.singOut();
          }     
          
        }else if (_typeUser == 'driver'){  
          Driver? driver = await _driverProvider!.getById(_authProvider!.getUser()!.uid);
        
          if (driver != null){
            _progressDialog?.hide();
            Navigator.pushNamedAndRemoveUntil(context!, 'driver/map', (route) => false);
          }else{
            _progressDialog?.hide();
            utils.Snackbar.showSnackbar(context, key, 'Usuario No Válido');    
            await _authProvider?.singOut();
          }
        }
      }else{
        _progressDialog?.hide();
        utils.Snackbar.showSnackbar(context, key, 'Usuario No Autenticado');
      }

    } catch(error){
      _progressDialog?.hide();
      //utils.Snackbar.showSnackbar(context, key, 'Error: $error');
    }
    
  }
}