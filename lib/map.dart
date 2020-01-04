import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FoodHuntMap extends StatefulWidget {

  final FoodHuntMapController controller;

  FoodHuntMap({this.controller});

  @override
  _FoodHuntMapState createState() => _FoodHuntMapState();
}

class _FoodHuntMapState extends State<FoodHuntMap> {

  static const String _API_KEY = 'AIzaSyAI4tTbcJYVABnw7tJ4iP-Sx4EFyRadrAo';

  double latitude = 40.7484405;
  double longitude = -73.9878531;
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  GoogleMapController _controller;
//  static final CameraPosition _myLocation = CameraPosition(
//    target: LatLng(latitude, longitude),
//    zoom: 12,
//    bearing: 90.0,
//    tilt: 50.0,
//  );

  @override
  void initState() {
    super.initState();
    widget.controller?._addFunctions(reset);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 12,
          bearing: 90.0,
          tilt: 50.0,
        ),
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _setStyle(controller);
          _controller = controller;
        },
        myLocationButtonEnabled: false,
        compassEnabled: false,
      ),
    );
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  void reset() {
    print('hi');
  }

}

class FoodHuntMapController {

  VoidCallback _reset;

  void _addFunctions(
    VoidCallback reset
  ) {
    _reset = reset;
  }

  void reset() {
    _reset();
  }

}