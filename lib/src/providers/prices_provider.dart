import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/prices.dart';

class PricesProvider {

  late CollectionReference _ref;

  PricesProvider() {
    _ref = FirebaseFirestore.instance.collection('Prices');
  }

  Future<Prices> getAll() async {
    DocumentSnapshot document = await _ref.doc('info').get();
    Map<String, dynamic> json = document.data() as Map<String, dynamic>;
    Prices prices = Prices.fromJson(json);
    return prices;
  }

}