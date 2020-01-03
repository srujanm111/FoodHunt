import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:food_hunt/data_widgets.dart';
import 'package:food_hunt/main_panel.dart';
import 'package:food_hunt/panel.dart';
import 'package:food_hunt/recipe_panels.dart';
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

  PreferredSizeWidget _huntBar;

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
      appBar: _huntBar,
      body: SlidingUpPanel(
        controller: _panelController,
        maxHeight: _currentPanel.panelHeightOpen,
        minHeight: _currentPanel.panelHeightClosed,
        body: _body(),
        panel: _createPanel(),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
    );
  }

  Widget _createPanel() {
    return Controls(
      changePanel: _changePanelContents,
      startHunt: _startHunt,
      huntForIngredient: _huntForIngredient,
      closeHunt: _closeHunt,
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
  }

  void _startHunt(Recipe recipe) {
    // replace with ingredient closest to current location
    for (IngredientItem ingredientItem in recipe.ingredients) {
      if (!ingredientItem.found) {
        _huntBar = AppBar(
          title: Text(ingredientName[ingredientItem.ingredient]),
        );
        break;
      }
    }
  }

  void _huntForIngredient(IngredientItem ingredient) {
    _huntBar = AppBar(
      title: Text(ingredientName[ingredient.ingredient]),
    );
    setState(() {});
  }

  void _closeHunt() {
    _huntBar = null;
  }

}

class Controls extends InheritedWidget {

  final Function changePanel;
  final Function startHunt;
  final Function huntForIngredient;
  final Function closeHunt;

  Controls({
    @required this.changePanel,
    @required this.startHunt,
    @required this.huntForIngredient,
    @required this.closeHunt,
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
  final bool isOpenByDefault;

  Panel({
    this.panelHeightOpen = 575.0, 
    this.panelHeightClosed = 95.0,
    this.isOpenByDefault = true,
  });
  
}