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
    }catch(error){
      errorMessage = error.toString();
    }

    if (errorMessage.isEmpty){
      return Future.error(errorMessage);
    }
  }

  Future<Driver?> getById(String id) async {
    
    var document = await _ref?.doc(id).get();
  
    if (document!.exists){
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      Driver driver = Driver.fromJson(data!);
      return driver;
    }
    return null;
  }
}