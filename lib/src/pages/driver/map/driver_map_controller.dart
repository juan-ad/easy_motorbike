import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:easy_motorbike/src/utils/snackbar.dart' as utils;
import 'package:flutter/widgets.dart';

class DriverMapController {

  BuildContext? context;
  Function? refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(1.2287695, -77.2923158),
    zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position? _position;
  StreamSubscription<Position>? _positionStream;

  BitmapDescriptor? markerDriver;

  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    markerDriver = await createMarketImageFormAsset("assets/img/motocicleta.png");
    checkGPS();
    return null;
  }

  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void updateLocation() async{
    try{
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();

      addMarket(
        'driver',
        _position!.latitude,
        _position!.longitude,
        'Tu posición',
        '',
        markerDriver!
      );
      refresh!();

      _positionStream = Geolocator.getPositionStream().listen((Position position) {
        _position = position;
        addMarket(
          'driver',
          _position!.latitude,
          _position!.longitude,
          'Tu posición',
          '',
          markerDriver!
        );
        animateCameraToPosition(_position!.latitude, _position!.longitude);
       });
       refresh!();
    }catch(err){
      print("Error en la localización");
    }
  }

  void centerPosition(){
    if (_position != null){
      animateCameraToPosition(_position!.latitude, _position!.longitude);
    }else {
      utils.Snackbar.showSnackbar(context, key, "Activa el GPS para obtener la posición");
    }
  }

  void checkGPS() async{
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled){
      updateLocation();
    }else{

      bool locationGPS = await location.Location().requestService();
      if (locationGPS){
        updateLocation();
      }
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  
  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null){
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(latitude, longitude),
          zoom: 17
        )
      ));
    }
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
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: const Offset(0.5, 0.5),
      rotation: _position!.heading
    );
    markers[id] = marker;
  }
}