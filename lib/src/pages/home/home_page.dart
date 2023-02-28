import 'package:easy_motorbike/src/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

// StatelessWidget: se utiliza para mostrar información que no va a tener un estado cambiante
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeController _con = HomeController();

  @override
  Widget build(BuildContext context) {
    _con.init(context); // Inicializando el controlador para Home
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Easy MotorBike')
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.black, Colors.black87]
            )
          ),
          child: Column(
            children: [
              _bannerApp(size),
              const SizedBox(height: 30 ),
              _textSelectYourRole(),
              const SizedBox(height: 35 ),
              _imageTypeUser(context, 'assets/img/client.png', 'client'),
              const SizedBox(height: 10 ),
              _textTypeUser('Cliente'),
              const SizedBox(height: 35 ),
              _imageTypeUser(context, 'assets/img/motociclista.jpg', 'driver'),
              const SizedBox(height: 10 ),
              _textTypeUser('Motociclista')
          ],
          ),
        )
      ),
    );
  } 

  Widget _bannerApp(Size size){
    return ClipPath(
      clipper: DiagonalPathClipperTwo(),
      child: Container(
        color: Colors.white,
        height: size.height * 0.2,
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/motorbike.png',
              width: 120,
              height: 80,
            ),  
            const Text(
              'Fácil y Rápido',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textSelectYourRole(){
    return const Text(
      'SELECCIONA TU ROL',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'OneDay'
      ),
    );
  }

  Widget _imageTypeUser(BuildContext context, String image, String typeUser){
    return GestureDetector(
      onTap: () {
        _con.goToLoginPage(typeUser);
      },
      child: CircleAvatar(
        backgroundImage: AssetImage(image),
        radius: 50,
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  Widget _textTypeUser(String typeUser){
    return Text(
      typeUser,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16
      ),
    );
  }

}
