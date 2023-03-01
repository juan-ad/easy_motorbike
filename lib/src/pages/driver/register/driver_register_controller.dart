import 'package:easy_motorbike/src/models/driver.dart';
import 'package:easy_motorbike/src/providers/auth_provider.dart';
import 'package:easy_motorbike/src/providers/driver_provider.dart';
import 'package:easy_motorbike/src/utils/my_progress_dialog.dart';
import 'package:easy_motorbike/src/utils/snackbar.dart' as utils;
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class DriverRegisterController{

  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();
  TextEditingController pin6Controller = TextEditingController();

  AuthProvider? _authProvider;
  DriverProvider? _driverProvider;
  ProgressDialog? _progressDialog;

  Future? init(BuildContext context){
    this.context = context;
    _authProvider = AuthProvider();
    _driverProvider = DriverProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    return null;
  }

  Future<void> register() async {
    String username = usernameController.text;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();

    String plate = '$pin1$pin2$pin3-$pin4$pin5$pin6';

    if (username.isEmpty && email.isEmpty && password.isEmpty && confirmPassword.isEmpty){
      utils.Snackbar.showSnackbar(context, key, 'Todos los campos son obligatorios');
      return;
    }

    if (confirmPassword != password){
      utils.Snackbar.showSnackbar(context, key, 'Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6){
      utils.Snackbar.showSnackbar(context, key, 'El password debe tener al menos 3 carácteres');
      return;
    }

    _progressDialog?.show();

    try{
      bool? isRegister = await _authProvider?.register(email, password);

      if (isRegister == true){
        Driver driver = Driver(
          id: _authProvider!.getUser()!.uid, 
          username: username, 
          email: email, 
          password: password,
          plate: plate
        );
        await _driverProvider?.create(driver);
        _progressDialog?.hide();
        Navigator.pushNamedAndRemoveUntil(context!, 'driver/map', (route) => false);

        utils.Snackbar.showSnackbar(context, key, 'Motociclista Registrado Correctamente');
      }else{
        _progressDialog?.hide();
        utils.Snackbar.showSnackbar(context, key, 'Motociclista No Registrado');
      }

    } catch(error){
      _progressDialog?.hide();
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
    }
    
  }
}