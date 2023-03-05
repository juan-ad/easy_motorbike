import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeoFireProvider{
  
  CollectionReference? _ref;
  Geoflutterfire? _geo;

  GeoFireProvider(){
    _ref = FirebaseFirestore.instance.collection('Locations');
    _geo = Geoflutterfire();
  }

  Future<void> create(String id, double lat, double lng){
    GeoFirePoint myLocation = _geo!.point(latitude: lat, longitude: lng);
    return _ref!.doc(id).set({'status': 'drivers_available', 'position': myLocation.data});
  }

  Future <void> delete(String id){
    return _ref!.doc(id).delete();
  }
}
