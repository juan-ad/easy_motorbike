import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:easy_motorbike/src/utils/colors.dart' as utils;
import 'package:easy_motorbike/src/widgets/button_app.dart';
import 'package:easy_motorbike/src/pages/login/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final LoginController _con = LoginController();

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
            _textDescription(),
            _textLogin(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.17),
            _textFieldEmail(),
            _textFieldPassword(),
            _buttonLogin(),
            _textDontHaveAcoount()
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

  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: const Text(
        'Continua con tu',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 24,
          fontFamily: 'NimbusSans'
        ),
      )
    );
  }

  Widget _textLogin(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      )
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

  Widget _buttonLogin(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.login,
        text: 'Iniciar Sesión',
        color: utils.Colors.easyMotoColor,
        textColor: Colors.white,
      )
    );
  }

  Widget _textDontHaveAcoount() {
    return GestureDetector(
      onTap: _con.goToRegisterPage,
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: const Text(
          'No tienes cuenta?',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        )
      ),
    );
  }
}