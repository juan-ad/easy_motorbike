import 'package:flutter/material.dart';

class ClientTravelRequestController {
  late BuildContext context;
  late Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }
}