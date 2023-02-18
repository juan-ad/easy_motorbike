import 'package:flutter/material.dart';
import 'package:easy_motorbike/src/utils/colors.dart' as utils;

class Snackbar{

  static void showSnackbar(BuildContext? context, GlobalKey<ScaffoldState>? key, String text){
    if(context == null) return;
    if (key == null) return;

    FocusScope.of(context).requestFocus(FocusNode());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        )
      ),
      backgroundColor: utils.Colors.easyMotoColor,
      duration: const Duration(seconds: 3),
    ));
  }

}