import 'dart:convert';
import 'dart:async';
import 'package:easy_motorbike/src/api/enviroment.dart';
import 'package:http/http.dart' as http;

import '../models/directions.dart';


class GoogleProvider {

  Future<dynamic> getGoogleMapsDirections(double fromLat, double fromLng, double toLat, double toLng) async {

    Uri uri = Uri.https(
      'maps.googleapis.com',
      'maps/api/directions/json', {
        'key': Enviroment.API_KEY_MAPS,
        'origin': '$fromLat, $fromLng',
        'destination': '$toLat, $toLng',
        'traffic_model': 'best_guess',
        'departure_time': DateTime.now().microsecondsSinceEpoch.toString(),
        'mode': 'driving',
        'transit_routing_preferences': 'less_driving'
      }
    );
    print('URL: $uri');
    final response = await http.get(uri);
    final decodedData = json.decode(response.body);
    final leg = new Direction.fromJsonMap(decodedData['routes'][0]['legs'][0]);
    return leg;

  }
}