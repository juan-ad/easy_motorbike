import 'package:easy_motorbike/src/models/client.dart';
import 'package:easy_motorbike/src/pages/client/travel_info/client_travel_info_controller.dart';
import 'package:easy_motorbike/src/widgets/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientTravelInfoPage extends StatefulWidget {
  const ClientTravelInfoPage({Key? key}) : super(key: key);

  @override
  State<ClientTravelInfoPage> createState() => _ClientTravelInfoPageState();
}

class _ClientTravelInfoPageState extends State<ClientTravelInfoPage> {

  ClientTravelInfoController _con = new ClientTravelInfoController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            child: _googleMapsWidget(),
            alignment: Alignment.topCenter,
          ),
          Align(
            child: _cardTravelInfo(),
            alignment: Alignment.bottomCenter,
          ),
          Align(
            child: _buttonBack(),
            alignment: Alignment.topLeft,
          ),
          Align(
            child: _cardKmInfo('0 Km'),
            alignment: Alignment.topRight,
          ),
          Align(
            child: _cardMinInfo('0 Min'),
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }

  Widget _cardTravelInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.38,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
   ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Desde',
              style:TextStyle(
                fontSize: 15
              )
            ),
            subtitle: Text(
              'Cr falsa con calle falsa',
              style: TextStyle(
                fontSize: 13
              ),
            ),
            leading: Icon(Icons.my_location),
          ),
          ListTile(
            title: Text(
                'Hasta',
                style:TextStyle(
                    fontSize: 15
                )
            ),
            subtitle: Text(
              'Cr falsa con calle falsa',
              style: TextStyle(
                  fontSize: 13
              ),
            ),
            leading: Icon(Icons.location_on),
          ),
          ListTile(
            title: Text(
                'Precio',
                style:TextStyle(
                    fontSize: 15
                )
            ),
            subtitle: Text(
              '\$ 0.0',
              style: TextStyle(
                  fontSize: 13
              ),
            ),
            leading: Icon(Icons.attach_money),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: ButtonApp(
              onPressed: () {},
              text: 'CONFIRMAR',
              textColor: Colors.black,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardKmInfo(String km) {
    return SafeArea(
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
        margin: EdgeInsets.only(right: 10, top: 10),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Text(km ?? '0Km'),
      ),
    );
  }

  Widget _cardMinInfo(String min) {
    return SafeArea(
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
        margin: EdgeInsets.only(right: 10, top: 40),
        decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Text(min ?? '0 Min'),
      ),
    );
  }

  Widget _buttonBack() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    setState(() {});
  }

}
