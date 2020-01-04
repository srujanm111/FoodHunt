import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';

class FoodHuntMap extends StatefulWidget {

  final FoodHuntMapController controller;

  FoodHuntMap({this.controller});

  @override
  _FoodHuntMapState createState() => _FoodHuntMapState();
}

class _FoodHuntMapState extends State<FoodHuntMap> {

  static const String _API_KEY = 'AIzaSyAI4tTbcJYVABnw7tJ4iP-Sx4EFyRadrAo';

  final markerKey = GlobalKey();

  double latitude = 40.7484405;
  double longitude = -73.9878531;
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  GoogleMapController _controller;

  List<Marker> _markers = [];

  List<CustomMarker> _customMarkers = [];

  @override
  void initState() {
    super.initState();
    widget.controller?._addFunctions(
      _createMarker,
      _clearMarkers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Row(
            children: _customMarkers,
          ),
          GoogleMap(
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
            markers: Set.of(_markers),
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

  void _addMarker(MarkerId markerId, LatLng position, Uint8List bitmap, VoidCallback onPress) {
    _markers.add(Marker(
      markerId: markerId,
      position: position,
      icon: BitmapDescriptor.fromBytes(bitmap),
      onTap: onPress,
    ));
    setState(() {});
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
    _markers.clear();
    _customMarkers.clear();
    setState(() {});
  }

}

class FoodHuntMapController {

  Function(Widget icon, MarkerId markerId, LatLng position, VoidCallback onPress) _createMarker;
  VoidCallback _clearMarkers;

  void _addFunctions(
    Function(Widget icon, MarkerId markerId, LatLng position, VoidCallback onPress) createMarker,
    VoidCallback clearMarkers,
  ) {
    _createMarker = createMarker;
    _clearMarkers = clearMarkers;
  }

  void createMarker(Widget icon, MarkerId markerId, LatLng position, VoidCallback onPress) {
    _createMarker(icon, markerId, position, onPress);
  }

  void clearMarkers() {
    _clearMarkers();
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
      child: Image(
        image: AssetImage('assets/icons/marker.png'),
        height: 48,
        width: 48,
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

