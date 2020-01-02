import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:food_hunt/data_widgets.dart';
import 'package:food_hunt/main_sheet.dart';
import 'package:food_hunt/recipe_widgets.dart';
import 'package:food_hunt/custom_sheet_widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';
import 'data_classes.dart';


class BasePage extends StatefulWidget {
  BasePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {

  Widget _currentSheet = MainSheet();

  double _panelHeightOpen = 575.0;
  double _panelHeightClosed = 95.0;

  static const String _API_KEY = 'AIzaSyAI4tTbcJYVABnw7tJ4iP-Sx4EFyRadrAo';

  static double latitude = 40.7484405;
  static double longitude = -73.9878531;
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _myLocation = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 12,
    bearing: 15.0,
    tilt: 50.0,
  );

  PanelController _panelController = new PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        onPanelClosed: () {
          setState(() {});
          _panelController.show();
        },
        parallaxEnabled: false,
        body: _body(),
        panel: _createPanel(),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
    );
  }

  Widget _createPanel() {
    return Controls(
      changeSheet: _changeSheetContents,
      child: _currentSheet,
    );
  }

  Widget _body() {
    return GoogleMap(
      initialCameraPosition: _myLocation,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        _setStyle(controller);
        _controller.complete(controller);
      },
      myLocationButtonEnabled: false,
    );
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  void _changeSheetContents(Widget sheet) {
    _panelController.hide();
    _currentSheet = sheet;
  }

}

class Controls extends InheritedWidget {

  final Function changeSheet;

  Controls({
    @required this.changeSheet,
    @required Widget child,
  }) : super(child: child);

  static Controls of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Controls>();
  }

  @override
  bool updateShouldNotify(Controls oldWidget) => oldWidget.changeSheet != changeSheet;

}