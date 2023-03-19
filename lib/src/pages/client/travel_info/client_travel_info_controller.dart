import 'dart:async';

import 'package:easy_motorbike/src/api/enviroment.dart';
import 'package:easy_motorbike/src/models/directions.dart';
import 'package:easy_motorbike/src/providers/google_provider.dart';
import 'package:easy_motorbike/src/providers/prices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../models/prices.dart';

class ClientTravelInfoController {

  late BuildContext context;

  late GoogleProvider _googleProvider;
  late PricesProvider _pricesProvider;

  Function? refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = const CameraPosition(
      target: LatLng(1.2287695, -77.2923158),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late String from = '';
  late String to = '';
  late LatLng fromLatLng;
  late LatLng toLatLng;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  late BitmapDescriptor fromMarker;
  late BitmapDescriptor toMarker;

  late Direction _directions;
  late String min = '';
  late String km = '';

  late double minTotal = 0.0;
  late double maxTotal = 0.0;

  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    Map<String, dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _googleProvider = new GoogleProvider();
    _pricesProvider = new PricesProvider();

    fromMarker = await createMarketImageFormAsset("assets/img/map_pin_red.png");
    toMarker = await createMarketImageFormAsset("assets/img/map_pin_blue.png");

    animateCameraToPosition(fromLatLng.latitude, fromLatLng.longitude);
    getGoogleMapsDirections(fromLatLng, toLatLng);

  }

  void getGoogleMapsDirections(LatLng from, LatLng to) async {
    _directions= await _googleProvider.getGoogleMapsDirections(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude
    );
    min = _directions.duration.text;
    km = _directions.distance.text;
    print('KM: $km');
    print('Min: $min');
    calculatePrice();
    refresh!();
  }

  void goToRequest() {
    Navigator.pushNamed(context, 'client/travel/request');
  }

  void calculatePrice() async {
    Prices prices = await _pricesProvider.getAll();
    double kmValue = double.parse(km.split(" ")[0]) * prices.km;
    double minValue = double.parse(min.split(" ")[0]) * prices.min;
    double total = kmValue + minValue;

    // Validación para valor minimo base.
    double minimumValue = prices.minValue;
    total = total + minimumValue;

    print('TOTAL: $total');
    // Se asigna el valor estimado.
    if(total - 500 < minimumValue ){ // Se valida que el valor mínimo siempre sea el mismo.
      minTotal = minimumValue;
    }
    else{
      minTotal = total - 500;
    }
    maxTotal = total + 500;

    refresh!();

  }

  Future<void> setPolylines() async {
    PointLatLng pointFromLatLng = PointLatLng(fromLatLng.latitude, fromLatLng.longitude);
    PointLatLng pointToLatLng = PointLatLng(toLatLng.latitude, toLatLng.longitude);

    PolylineResult result = await new PolylinePoints().getRouteBetweenCoordinates(
        Enviroment.API_KEY_MAPS,
        pointFromLatLng,
        pointToLatLng
    );

    for(PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: Colors.amber,
      points: points,
      width: 6
    );

    polylines.add(polyline);

    addMarket('from', fromLatLng.latitude, fromLatLng.longitude, 'Recoger aquí', '', fromMarker);
    addMarket('to', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);
    refresh!();

  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null){
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 15
          )
      ));
    }
  }

  void onMapCreated(GoogleMapController controller) async{
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
    await setPolylines();
  }

  // Nos permite transformar una imagen a un marcador
  Future<BitmapDescriptor> createMarketImageFormAsset(String path) async{
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }


  void addMarket(String marketId, double lat, double lng, String title, String content, BitmapDescriptor iconMarket){
    MarkerId id = MarkerId(marketId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarket,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: title,
            snippet: content
        ),
    );
    markers[id] = marker;
  }


}

