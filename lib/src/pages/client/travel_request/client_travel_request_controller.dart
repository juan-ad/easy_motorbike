import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_motorbike/src/models/travel_info.dart';
import 'package:easy_motorbike/src/providers/auth_provider.dart';
import 'package:easy_motorbike/src/providers/driver_provider.dart';
import 'package:easy_motorbike/src/providers/geofire_provider.dart';
import 'package:easy_motorbike/src/providers/travel_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientTravelRequestController {
  late BuildContext context;
  late Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  late String from = '';
  late String to = '';
  late LatLng fromLatLng;
  late LatLng toLatLng;

  late TravelInfoProvider _travelInfoProvider;
  late AuthProvider _authProvider;
  late DriverProvider _driverProvider;
  late GeoFireProvider _geoFireProvider;

  late List<String> nearbyDrivers = [];

  late StreamSubscription<List<DocumentSnapshot>> _streamSubscription;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _geoFireProvider = new GeoFireProvider();

    Map<String, dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _createTravelInfo();
    _getNearbyDrivers();
  }

  void dispose() {
    _streamSubscription?.cancel();
  }

  void _getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = _geoFireProvider.getNearbyDrivers(
        fromLatLng.latitude,
        fromLatLng.longitude,
        10
    );

    _streamSubscription = stream.listen((List<DocumentSnapshot> documentList) {
      for(DocumentSnapshot d in documentList) {
        print('CONDUCTOR ENCONTRADO ${d.id}');
        nearbyDrivers.add(d.id);
      }
    });




  }

  void _createTravelInfo() async {
    TravelInfo travelInfo = new TravelInfo(
        id: _authProvider.getUser()?.uid,
        from: from,
        to: to,
        fromLat: fromLatLng.latitude,
        fromLng: fromLatLng.longitude,
        toLat: toLatLng.latitude,
        toLng: toLatLng.longitude,
        status: 'created'
    );

    await _travelInfoProvider.create(travelInfo);
  }

}