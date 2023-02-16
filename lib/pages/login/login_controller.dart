import 'package:flutter/material.dart';

class LoginController{

  BuildContext? context;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future? init(BuildContext context){
    this.context = context;
    return null;
  }

  void login(){
    String email = emailController.text;
    String password = passwordController.text;

    print("Email: $email");
    print("Password: $password");
  }
}