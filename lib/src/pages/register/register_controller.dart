import 'package:easy_motorbike/src/models/client.dart';
import 'package:easy_motorbike/src/providers/auth_provider.dart';
import 'package:easy_motorbike/src/providers/client_provider.dart';
import 'package:easy_motorbike/src/utils/my_progress_dialog.dart';
import 'package:easy_motorbike/src/utils/snackbar.dart' as utils;
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class RegisterController{

  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  AuthProvider? _authProvider;
  ClientProvider? _clientProvider;
  ProgressDialog? _progressDialog;

  Future? init(BuildContext context){
    this.context = context;
    _authProvider = AuthProvider();
    _clientProvider = ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    return null;
  }

  Future<void> register() async {
    String username = usernameController.text;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

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
        Client client = Client(
          id: _authProvider!.getUser()!.uid, 
          username: username, 
          email: email, 
          password: password
        );
        await _clientProvider?.create(client);
        _progressDialog?.hide();
        utils.Snackbar.showSnackbar(context, key, 'Usuario Registrado Correctamente');
      }else{
        _progressDialog?.hide();
        utils.Snackbar.showSnackbar(context, key, 'Usuario No Registrar');
      }

    } catch(error){
      _progressDialog?.hide();
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
    }
    
  }
}