import 'package:easy_motorbike/src/pages/client/travel_request/client_travel_request_controller.dart';
import 'package:easy_motorbike/src/widgets/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:easy_motorbike/src/utils/colors.dart' as utils;
import 'package:lottie/lottie.dart';

class ClientTravelRequestPage extends StatefulWidget {
  const ClientTravelRequestPage({Key? key}) : super(key: key);

  @override
  State<ClientTravelRequestPage> createState() => _ClientTravelRequestPageState();
}

class _ClientTravelRequestPageState extends State<ClientTravelRequestPage> {

  ClientTravelRequestController _con = new ClientTravelRequestController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _driverInfo(),
            _lottieAnimation(),
            _textLookingFor(),
            _textCounter(),
          ],
        ),
        bottomNavigationBar: _buttonCancel(),
      ),
    );
  }

  Widget _lottieAnimation() {
    return Lottie.asset(
      'assets/json/moto-control.json',
      width: MediaQuery.of(context).size.width * 0.66,
      height: MediaQuery.of(context).size.height * 0.33,
      fit: BoxFit.fill
    );
  }

  Widget _buttonCancel() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(30),
      child: ButtonApp(
        text: 'Cancelar viaje',
        color: Colors.amber,
        icon: Icons.cancel_outlined,
        textColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _textCounter() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        '0',
        style: TextStyle(
          fontSize: 30
        ),
      ),
    );
  }

  Widget _textLookingFor() {
    return Container(
      child: Text(
        'Buscando conductor',
        style: TextStyle(
          fontSize: 16
        ),
      ),
    );
  }

  Widget _driverInfo() {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        color: utils.Colors.easyMotoColor,
        width: double.infinity,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/img/profile.jpg'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Tu conductor',
                maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
