import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

// StatelessWidget: se utiliza para mostrar información que no va a tener un estado cambiante
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              _imageTypeUser('assets/img/client.png'),
              const SizedBox(height: 10 ),
              _textTypeUser('Cliente'),
              const SizedBox(height: 35 ),
              _imageTypeUser('assets/img/motociclista.jpg'),
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

  Widget _imageTypeUser(String image){
    return CircleAvatar(
      backgroundImage: AssetImage(image),
      radius: 50,
      backgroundColor: Colors.grey[800],
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
