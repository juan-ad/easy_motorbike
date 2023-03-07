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

  Future<Client?> getById(String id) async {
    var document = await _ref?.doc(id).get();

    if (document!.exists){
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      Client client = Client.fromJson(data!);
      return client;
    }
    return null;
  }

  Stream<DocumentSnapshot> getByIdStream(String id){
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }
}