import 'package:flutter/material.dart';
import 'package:easy_motorbike/src/utils/colors.dart' as utils;

// ignore: must_be_immutable
class ButtonApp extends StatelessWidget{

  Color color;
  Color textColor;
  String text;
  IconData icon;
  Function onPressed;

  ButtonApp({
    super.key, 
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.icon = Icons.arrow_forward_ios,
    required this.onPressed,
    required this.text
  });

  @override
  Widget build(BuildContext context){
    return OutlinedButton(
      onPressed: () {
        onPressed();
      }, 
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        textStyle: TextStyle(
          color: textColor
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      ), 
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ),
          Align(
            alignment: Alignment.centerRight,
            // ignore: sized_box_for_whitespace
            child: Container(
              height: 50,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(
                  icon, 
                  color: utils.Colors.easyMotoColor,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}