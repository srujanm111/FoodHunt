import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_hunt/data_classes.dart';
import 'package:food_hunt/game_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';

class FoodHuntMap extends StatefulWidget {

  final FoodHuntMapController controller;

  FoodHuntMap({this.controller});

  @override
  _FoodHuntMapState createState() => _FoodHuntMapState();
}

class _FoodHuntMapState extends State<FoodHuntMap> {

  final markerKey = GlobalKey();

  static double latitude = 40.7484405;
  static double longitude = -73.9878531;
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  GoogleMapController _controller;

  List<Marker> _markers = [];
  List<CustomMarker> _customMarkers = [];

  List<Circle> _hintCircles = [];

  List<Polyline> _polylines = [];

  @override
  void initState() {
    super.initState();
    widget.controller?._addFunctions(
      _createMarker,
      _createHintCircle,
      _clearMarkers,
      _clearCircles,
      _animateTo,
      _drawPolyline,
      _clearPolylines,
    );
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/icons/marker.png'), context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Stack(
            children: _customMarkers,
          ),
          GoogleMap(
            myLocationEnabled: true,
            circles: Set.of(_hintCircles),
            initialCameraPosition: CameraPosition(
              target: LatLng(GameManager.instance.storedGameData.startPosition.latitude, GameManager.instance.storedGameData.startPosition.longitude),
              zoom: 12,
              tilt: 10.0,
            ),
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _setStyle(controller);
              _controller = controller;
            },
            myLocationButtonEnabled: false,
            markers: Set.of(_markers),
            polylines: Set.of(_polylines),
          ),
        ],
      ),
    );
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }
  
  void _createHintCircle(LatLng position) {
    _hintCircles.add(Circle(
      center: position,
      radius: 200,
      fillColor: Color.fromRGBO(primary.red, primary.green, primary.blue, .3),
      strokeColor: Color(0xFF7582FB),
      circleId: CircleId(GlobalKey().toString()),
    ));
  }
  
  void _clearCircles() {
    setState(() {
      _hintCircles.clear();
    });
  }

  void _drawPolyline(Polyline route) {
    setState(() {
      _polylines.add(route);
    });
  }

  void _clearPolylines() {
    setState(() {
      _polylines.clear();
    });
  }

  void _addMarker(MarkerId markerId, LatLng position, Uint8List bitmap, VoidCallback onPress) {
    setState(() {
      _markers.add(Marker(
        markerId: markerId,
        position: position,
        icon: BitmapDescriptor.fromBytes(bitmap),
        onTap: onPress,
      ));
    });
  }

  void _createMarker(Widget icon, MarkerId markerId, LatLng position, VoidCallback onPress) {
    _customMarkers.add(CustomMarker(
      child: icon,
      createMarker: _addMarker,
      markerId: markerId,
      position: position,
      onPress: onPress,
    ));
  }

  void _clearMarkers() {
    setState(() {
      _markers.clear();
      _customMarkers.clear();
    });
  }

  void _animateTo(LatLng position) {
    _controller.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }

}

class FoodHuntMapController {

  Function(Widget icon, MarkerId markerId, LatLng position, VoidCallback onPress) _createMarker;
  Function(LatLng position) _createHintCircle;
  VoidCallback _clearMarkers;
  VoidCallback _clearCircles;
  Function(LatLng position) _animateTo;
  Function(Polyline route) _drawPolyLine;
  VoidCallback _clearPolyLines;

  void _addFunctions(
    Function(Widget icon, MarkerId markerId, LatLng position, VoidCallback onPress) createMarker,
    Function(LatLng position) createHintCircle,
    VoidCallback clearMarkers,
    VoidCallback clearCircles,
    Function(LatLng position) animateTo,
    Function(Polyline route) drawPolyLine,
    VoidCallback clearPolyLines,
  ) {
    _createMarker = createMarker;
    _clearMarkers = clearMarkers;
    _createHintCircle = createHintCircle;
    _clearCircles = clearCircles;
    _animateTo = animateTo;
    _drawPolyLine = drawPolyLine;
    _clearPolyLines = clearPolyLines;
  }

  void createMarker(Widget icon, MarkerId markerId, LatLng position, VoidCallback onPress) {
    _createMarker(icon, markerId, position, onPress);
  }

  void clearMarkers() {
    _clearMarkers();
  }
  
  void createHintCircle(LatLng position) {
    _createHintCircle(position);
  }

  void clearCircles() {
    _clearCircles();
  }

  void animateTo(LatLng position) {
    _animateTo(position);
  }

  void drawPolyLine(Polyline route) {
    _drawPolyLine(route);
  }

  void clearPolyLines() {
    _clearPolyLines();
  }

}

class CustomMarker extends StatefulWidget {

  final Widget child;
  final MarkerId markerId;
  final LatLng position;
  final Function(MarkerId markerId, LatLng position, Uint8List bitmap, VoidCallback onPress) createMarker;
  final VoidCallback onPress;

  CustomMarker({
    this.child,
    this.markerId,
    this.position,
    this.createMarker,
    this.onPress
  });

  @override
  _CustomMarkerState createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker> with AfterLayoutMixin {

  final markerKey = GlobalKey();

  Future<Uint8List> _getUint8List() async {
    RenderRepaintBoundary boundary = markerKey.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 2.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: markerKey,
      child: Container(
        height: 60,
        width: 60,
        child: Stack(
          children: <Widget>[
            Image(
              image: AssetImage('assets/icons/marker.png'),
              height: 60,
              width: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(child: widget.child),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _getUint8List().then((bitmap) {
      widget.createMarker(widget.markerId, widget.position, bitmap, widget.onPress);
    });
  }
}

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context);
}

