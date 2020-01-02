import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:food_hunt/recipe_widgets.dart';
import 'package:food_hunt/custom_sheet_widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class BasePage extends StatefulWidget {
  BasePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        parallaxEnabled: false,
        body: _body(),
        panel: _panel(),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
    );
  }

  Widget _panel() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))
                ),
              ),
            ],
          ),
        ),
        ListHeader(title: "Recomended Recipe Hunts", trailing: ListActionButton(title: "View All", onPress: () {},),),
      ],
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

}
