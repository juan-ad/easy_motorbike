import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:easy_motorbike/src/utils/colors.dart' as utils;
import 'package:easy_motorbike/src/widgets/button_app.dart';
import 'package:easy_motorbike/src/pages/client/register/client_register_controller.dart';

class ClientRegisterPage extends StatefulWidget {
  const ClientRegisterPage({super.key});
  
  @override
  State<ClientRegisterPage> createState() => _ClientRegisterPageState();
}

class _ClientRegisterPageState extends State<ClientRegisterPage> {

  final ClientRegisterController _con = ClientRegisterController();

  @override
  void initState(){
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textLogin(),
            _textFieldUsername(),
            _textFieldEmail(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _buttonRegister(),
          ],
        ),
      ),
    );
  }

  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: utils.Colors.easyMotoColor,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Row( 
          crossAxisAlignment: CrossAxisAlignment.start,
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
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textLogin(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: const Text(
        'REGISTRO',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      )
    );
  }

  Widget _textFieldUsername() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        obscureText: false,
        controller: _con.usernameController,
        decoration: const InputDecoration(
          hintText: 'Usuario 1',
          labelText: 'Nombre de usuario',
          suffixIcon: Icon(
            Icons.person_outline,
            color: utils.Colors.easyMotoColor
          )
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        obscureText: false,
        controller: _con.emailController,
        decoration: const InputDecoration(
          hintText: 'correo@gmail.com',
          labelText: 'Correo electrónico',
          suffixIcon: Icon(
            Icons.email_outlined,
            color: utils.Colors.easyMotoColor
          )
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        obscureText: true,
        controller: _con.passwordController,
        decoration: const InputDecoration(
          labelText: 'Contraseña',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: utils.Colors.easyMotoColor
          )
        ),
      ),
    );
  }

   Widget _textFieldConfirmPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        obscureText: true,
        controller: _con.confirmPasswordController,
        decoration: const InputDecoration(
          labelText: 'Confirmar Contraseña',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: utils.Colors.easyMotoColor
          )
        ),
      ),
    );
  }

  Widget _buttonRegister(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.register,
        text: 'Registrar Ahora',
        color: utils.Colors.easyMotoColor,
        textColor: Colors.white,
      )
    );
  }

}