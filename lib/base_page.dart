import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:food_hunt/data_widgets.dart';
import 'package:food_hunt/main_panel.dart';
import 'package:food_hunt/recipe_panels.dart';
import 'package:food_hunt/custom_panel_widgets.dart';
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

  PanelController _panelController = new PanelController();
  Panel _currentPanel;

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

  @override
  Widget build(BuildContext context) {
    if (_currentPanel == null) {
      _currentPanel = MainPanel(MediaQuery.of(context).size.height);
    }
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        maxHeight: _currentPanel.panelHeightOpen,
        minHeight: _currentPanel.panelHeightClosed,
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
      changePanel: _changePanelContents,
      child: _currentPanel,
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

  void _changePanelContents(Widget sheet) {
    _panelController.hide();
    _currentPanel = sheet;
  }

}

class Controls extends InheritedWidget {

  final Function changePanel;

  Controls({
    @required this.changePanel,
    @required Widget child,
  }) : super(child: child);

  static Controls of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Controls>();
  }

  @override
  bool updateShouldNotify(Controls oldWidget) => oldWidget.changePanel != changePanel;

}

abstract class Panel extends StatefulWidget {

  final double panelHeightOpen;
  final double panelHeightClosed;

  Panel({
    this.panelHeightOpen = 575.0, 
    this.panelHeightClosed = 95.0,
  });
  
}