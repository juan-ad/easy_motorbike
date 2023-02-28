import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_motorbike/src/models/driver.dart';

class DriverProvider {

  CollectionReference? _ref;

  DriverProvider(){
    _ref = FirebaseFirestore.instance.collection('Drivers');
  }

  Future<void> create(Driver driver) async {
    String errorMessage = "";

    try{
      return _ref?.doc(driver.id).set(driver.toJson());
      print("MOTOCICLISTA REGISTRADO");
    }catch(error){
      errorMessage = error.toString();
    }

    if (errorMessage.isEmpty){
      return Future.error(errorMessage);
    }
  }
}