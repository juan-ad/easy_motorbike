import 'package:flutter/material.dart';

class DriverMapPage extends StatefulWidget{
  const DriverMapPage({super.key});
  
  @override
  State<DriverMapPage> createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage>{
  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(child: Text("Mapa del Conductor")),
    );
  }
}