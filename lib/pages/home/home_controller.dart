import 'package:flutter/material.dart';

class HomeController {
  
  BuildContext? context;

  Future? init(BuildContext context){ 
    this.context = context;
    return null;
  }

  void goToLoginPage() {
    Navigator.pushNamed(context!, 'login');
  }
}