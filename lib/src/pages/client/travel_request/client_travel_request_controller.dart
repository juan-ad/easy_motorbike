import 'package:easy_motorbike/src/models/travel_info.dart';
import 'package:easy_motorbike/src/providers/auth_provider.dart';
import 'package:easy_motorbike/src/providers/driver_provider.dart';
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

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();

    Map<String, dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _createTravelInfo();
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