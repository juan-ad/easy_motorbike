import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_motorbike/src/api/enviroment.dart';
import 'package:easy_motorbike/src/models/client.dart';
import 'package:easy_motorbike/src/providers/auth_provider.dart';
import 'package:easy_motorbike/src/providers/client_provider.dart';
import 'package:easy_motorbike/src/providers/driver_provider.dart';
import 'package:easy_motorbike/src/providers/geofire_provider.dart';
import 'package:easy_motorbike/src/utils/my_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:easy_motorbike/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:flutter_google_places/flutter_google_places.dart';

class ClientMapController{
  late BuildContext context;
  Function? refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(1.2287695, -77.2923158),
    zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position? _position;
  // Almacenar el listen de la actualización de la ubicación 
  StreamSubscription<Position>? _positionStream;

  BitmapDescriptor? markerDriver;

  GeoFireProvider _geoFireProvider = new GeoFireProvider();
  AuthProvider? _authProvider;
  DriverProvider? _driverProvider;
  ClientProvider? _clientProvider;

  bool isConnect = false;
  ProgressDialog? _progressDialog;

  StreamSubscription<DocumentSnapshot>? _statusSuscription;
  StreamSubscription<DocumentSnapshot>? _clientInfoSuscription;

  Client? client;

  String? from;
  LatLng? fromLatLng;

  String? to;
  LatLng? toLatLng;

  bool isFromSelected = true;

  places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(apiKey: Enviroment.API_KEY_MAPS);

  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    _geoFireProvider = new GeoFireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = DriverProvider();
    _clientProvider = ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Conectándose ...");
    markerDriver = await createMarketImageFormAsset("assets/img/motocicleta.png");
    checkGPS();
    getClientInfo();
    return null;
  }

  void getClientInfo(){
    Stream<DocumentSnapshot> clientStream = _clientProvider!.getByIdStream(_authProvider!.getUser()!.uid);
    _clientInfoSuscription = clientStream.listen((DocumentSnapshot document) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      client = Client.fromJson(data!);
      refresh!();
    });
  }

  void openDrawer(){
    key.currentState!.openDrawer();
  }

  void dispose(){
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _clientInfoSuscription?.cancel();
  }

  void signOut() async{
    await _authProvider!.singOut();
    Navigator.pushNamedAndRemoveUntil(context!, 'home', (route) => false);
  }

  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void disconnect(){
    _positionStream?.cancel();
    _geoFireProvider.delete(_authProvider!.getUser()!.uid);
  }

  void updateLocation() async{
    try{
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();
      getNearbyDrivers();
    }catch(err){
      print("Error en la localización");
    }
  }

  void requestDriver(){
    Navigator.pushNamed(context, 'client/travel/info');
  }

  void changeFromTO(){
    isFromSelected = !isFromSelected;

    if(isFromSelected){
      utils.Snackbar.showSnackbar(context, key, 'Estás seleccionando el lugar de recogida');
    }
    else{
      utils.Snackbar.showSnackbar(context, key, 'Estás seleccionando el destino');
    }
  }

  Future<Null> showGoogleAutocomplete(bool isFrom) async{
    places.Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Enviroment.API_KEY_MAPS,
      language: 'es',
      strictbounds: true,
      radius: 15000,
      location: places.Location(lat: 1.213611,lng: -77.3123281)
    );

    if(p != null){
      places.PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(p.placeId.toString(),language: 'es');
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;
      List<Address> address = await Geocoder.local.findAddressesFromQuery(p.description.toString());
      if(address != null){
        if(address.length > 0){
          if(detail != null){
            String direction = detail.result.name;
            String city = address[0].locality.toString();
            String department = address[0].adminArea.toString();

            if(isFrom){
              from = '$direction, $city, $department';
              fromLatLng = new LatLng(lat, lng);
            }
            else{
              to = '$direction, $city, $department';
              toLatLng = new LatLng(lat, lng);
            }


            refresh!();
          }
        }
      }

    }
  }

  Future<Null> setLocationDraggableInfo() async{
    final _position = this._position;
    if(initialPosition != null){
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat,lng);

      if(address != null){
        if(address.length > 0){
          String? direction = address[0].thoroughfare;
          String? street = address[0].subThoroughfare;
          String? city = address[0].locality;
          String? department = address[0].administrativeArea;
          String? country = address[0].country;

          if(isFromSelected){
            from = '$direction #$street, $city, $department';
            fromLatLng = new LatLng(lat,lng);
          }
          else{
            to = '$direction #$street, $city, $department';
            toLatLng = new LatLng(lat,lng);
          }

          refresh!();
        }
      }
    }
  }

  void getNearbyDrivers(){
    Stream<List<DocumentSnapshot>> stream = _geoFireProvider.getNearbyDrivers(
      _position!.latitude, _position!.longitude, 10);

    stream.listen((List<DocumentSnapshot> documentList) {
      for (MarkerId m in markers.keys){
         bool remove = true;

        for (DocumentSnapshot d in documentList){
          if(m.value == d.id){
            remove = false;
          }
        }

        if(remove){
          markers.remove(m);
          refresh!();
        }
      }

      for (DocumentSnapshot d in documentList){
        
        GeoPoint point = (d.data() as Map)['position']['geopoint'];
        addMarket(
          d.id,
          point.latitude,
          point.longitude,
          'Conductor disponible',
          '',
          markerDriver!);
      }
      refresh!();
    });
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
          zoom: 13
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