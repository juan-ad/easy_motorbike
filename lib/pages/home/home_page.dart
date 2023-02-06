import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy MotorBike')
      ),
      body: Column(
        children: [
          Row( 
            children: [
              Image.asset(
                'assets/img/motorbike.png',
                width: 150,
                height: 100,
              ),
              const Text('Fácil y Rápido')
            ],
          )
        ],
      )
    );
  }
}
