import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_motorbike/src/models/client.dart';

class ClientProvider {

  CollectionReference? _ref;

  ClientProvider(){
    _ref = FirebaseFirestore.instance.collection('Clients');
  }

  Future<void> create(Client client) async {
    String errorMessage = "";

    try{
      return _ref?.doc(client.id).set(client.toJson());
    }catch(error){
      errorMessage = error.toString();
    }

    if (errorMessage.isEmpty){
      return Future.error(errorMessage);
    }
  }
}