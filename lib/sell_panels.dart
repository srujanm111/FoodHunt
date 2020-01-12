import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt/game_manager.dart';
import 'package:food_hunt/panel_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';

import 'base_page.dart';
import 'constants.dart';
import 'data_classes.dart';
import 'data_widgets.dart';
import 'main_panel.dart';

class SellListPanel extends Panel {

  static final double scale = 0.7;

  SellListPanel(double screenHeight) : super(panelHeightOpen: screenHeight * scale, panelHeightClosed: 193);

  @override
  State createState() => _SellListPanelState();

}

class _SellListPanelState extends State<SellListPanel> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PanelTab(),
        PanelHeader(title: "Sell Your Food", onClose: () {
          Controls.of(context).changePanel(MainPanel(MediaQuery.of(context).size.height));
        },),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: _contents(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _contents() {
    List<Widget> widgets = [];
    for (Recipe recipe in GameManager.instance.storedGameData.recipesToBeSold) {
      widgets.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: SellRecipeItem(recipe: recipe,),
        onTap: () {
          Controls.of(context).changePanel(SellLocationListPanel(recipe, MediaQuery.of(context).size.height));
        },
      ));
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.removeLast();
    return widgets;
  }

}

class SellLocationListPanel extends Panel {

  final Recipe recipe;
  static final double scale = 0.7;

  SellLocationListPanel(this.recipe, double screenHeight) : super(panelHeightOpen: screenHeight * scale, panelHeightClosed: 193);

  @override
  _SellLocationListPanelState createState() => _SellLocationListPanelState();
}

class _SellLocationListPanelState extends State<SellLocationListPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PanelTab(),
        PanelHeader(title: "Select A ${sellLocationName[widget.recipe.sellLocation]}", onClose: () {
          Controls.of(context).changePanel(MainPanel(MediaQuery.of(context).size.height));
        },),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder<List<Widget>>(
              future: _contents(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data,
                  );
                }
                else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Widget>> _contents() async {
    List<Widget> widgets = [];
    List<PlacesSearchResult> places = await _getSellLocations();
    Position position = await GameManager.instance.locationUtility.getCurrentPosition();
    for (PlacesSearchResult place in places) {
      double dist = await GameManager.instance.locationUtility.distanceBetweenPoints(place.geometry.location.lat, place.geometry.location.lng, position.latitude, position.longitude);
      widgets.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: SellLocationItem(place, dist),
        onTap: () {
          Controls.of(context).changePanel(SellLocationDetailsPanel(widget.recipe, place, dist, MediaQuery.of(context).size.height));
        },
      ));
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.removeLast();
    return widgets;
  }

  Future<List<PlacesSearchResult>> _getSellLocations() async {
    Position currentPos = await GameManager.instance.locationUtility.getCurrentPosition();
    return (await GameManager.instance.googleMapsPlaces.searchNearbyWithRankBy(Location(currentPos.latitude, currentPos.longitude), "distance", type: sellLocationSearchParameter[widget.recipe.sellLocation])).results;
  }

}

class SellLocationDetailsPanel extends Panel {

  static final double scale = 0.7;
  final PlacesSearchResult place;
  final double miles;
  final Recipe recipe;

  SellLocationDetailsPanel(this.recipe, this.place, this.miles, double screenHeight) : super(panelHeightOpen: screenHeight * scale, panelHeightClosed: 193, isOpenByDefault: false);

  @override
  _SellLocationDetailsPanelState createState() => _SellLocationDetailsPanelState();
}

class _SellLocationDetailsPanelState extends State<SellLocationDetailsPanel> {

  bool showDirections = false;

  @override
  Widget build(BuildContext context) {
    _createMarker();
    return Column(
      children: <Widget>[
        PanelTab(),
        PanelHeader(
          title: widget.place.name,
          subTitle: _details(),
          actionButton: _button(),
          onClose: () {
            Controls.of(context).mapController.clearPolyLines();
            Controls.of(context).changePanel(SellListPanel(MediaQuery.of(context).size.height));
          },
        ),
        FutureBuilder<Widget>(
          future: _additionalDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            );
          },
        )
      ],
    );
  }

  void _createMarker() {
    Controls.of(context).mapController.createMarker(
        Image.network(
          widget.place.icon,
          height: 30,
          width: 30,
          color: white,
        ),
        map.MarkerId(GlobalKey().toString()),
        map.LatLng(widget.place.geometry.location.lat, widget.place.geometry.location.lng), null);
  }

  Widget _button() {
    return Row(
      children: <Widget>[
        Expanded(
          child: CupertinoButton(
            color: primary,
            child: Text(!showDirections ? "Directions" : "Sell"),
            onPressed: () {
              if (showDirections == false) {
                setState(() {
                  showDirections = true;
                });
              } else {
                _sellAction();
              }
            },
          ),
        ),
        showDirections ? FutureBuilder<Widget>(
          future: _showRoute(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CircularProgressIndicator(),
            );
          },
        ) : Container(),
      ],
    );
  }

  void _sellAction() async {
    Position curPos = await GameManager.instance.locationUtility.getCurrentPosition();
    Position destination = Position(latitude: widget.place.geometry.location.lat, longitude: widget.place.geometry.location.lng);
    double dist = await GameManager.instance.locationUtility.distanceBetweenPoints(curPos.latitude, curPos.longitude, destination.latitude, destination.longitude);
    bool inRange = dist < .1;
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(child: Text(inRange ? "Sell Food Item?" : "Not Close Enough!")),
          content: Container(
            width: 150,
            height: 55,
            decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(8)
            ),
            child: CupertinoButton(
              child: Center(child: Text(inRange ? 'Yes' : 'Continue', style: TextStyle(color: Colors.white),)),
              onPressed: () {
                Navigator.of(context).pop();
                if (inRange) {
                  // sell item
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _locationDetails(),
        _ratingDetails(),
      ],
    );
  }

  Widget _locationDetails() {
    return Text("${widget.place.vicinity.substring(widget.place.vicinity.indexOf(", ") + 2)} • ${widget.miles.toStringAsFixed(2)} mi", style: Theme.of(context).textTheme.subtitle,);
  }

  Widget _ratingDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          height: 16,
          width: 16,
          image: AssetImage("assets/icons/star.png"),
          color: yellow,
        ),
        Text("${widget.place.rating} • ", style: Theme.of(context).textTheme.subtitle.apply(color: yellow),),
        Text("${_priceLevel()} bonus", style: Theme.of(context).textTheme.subtitle.apply(color: green),),
      ],
    );
  }

  String _priceLevel() {
    if (widget.place.priceLevel == null) return "\$";
    String price = "\$";
    for (int i = 1; i < widget.place.priceLevel.index; i++) {
      price += "\$";
    }
    return price;
  }

  Future<Widget> _additionalDetails() async {
    PlaceDetails placeDetails = await _getPlaceDetails();
    List<Widget> widgets = [SizedBox(height: 15,)];

    widgets.add(ListHeader(
      title: "Details",
    ));
    Map<IconData, String> info = _iconInfo(placeDetails);
    for (MapEntry pair in info.entries) {
      widgets.add(
        _listTile(pair.key, pair.value),
      );
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.add(SizedBox(height: 15,));

    widgets.add(ListHeader(
      title: "Pictures",
    ));
    List<Photo> photos = placeDetails.photos;
    double pictureSize = 150;
    widgets.add(Container(
      height: pictureSize + 16,
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: pictureSize,
              width: pictureSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.network(_photoURL(photos[index])).image
                )
              ),
            ),
          );
        },
      ),
    ));

    widgets.add(ListHeader(
      title: "Reviews",
    ));
    for (Review review in placeDetails.reviews) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ReviewItem(review),
      ));
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.removeLast();

    widgets.add(SizedBox(height: 50,));

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  String _photoURL(Photo photo) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo.photoReference}&key=${GameManager.apiKey}";
  }

  Map<IconData, String> _iconInfo(PlaceDetails placeDetails) {
    Map<IconData, String> map = {};
    map[Icons.location_on] = "${placeDetails.addressComponents[1].longName} ${placeDetails.addressComponents[2].longName}, ${placeDetails.addressComponents[4].longName}, ${placeDetails.addressComponents[6].longName} ${placeDetails.addressComponents[8].longName}";
    map[Icons.phone] = placeDetails.formattedPhoneNumber;
    map[Icons.access_time] = placeDetails.openingHours.openNow ? "Open" : "Closed";
    map[Icons.web] = placeDetails.website;
    return map;
  }

  Widget _listTile(IconData icon, String text) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Icon(icon, color: primary,),
        ),
        Text(text, style: Theme.of(context).textTheme.caption.apply(color: black),)
      ],
    );
  }

  Future<PlaceDetails> _getPlaceDetails() async {
    PlacesDetailsResponse response = await GameManager.instance.googleMapsPlaces.getDetailsByPlaceId(widget.place.placeId);
    return response.result;
  }

  Future<Widget> _showRoute() async {
    Position pos = await GameManager.instance.locationUtility
        .getCurrentPosition();
    DirectionsResponse directionsResponse = await GameManager.instance
        .googleMapsDirections.directionsWithLocation(
        Location(pos.latitude, pos.longitude),
        widget.place.geometry.location);
    Controls.of(context).mapController.drawPolyLine(map.Polyline(
      polylineId: map.PolylineId('route1'),
      points: _decodePoly(directionsResponse.routes[0].overviewPolyline.points),
      color: primary,
      visible: true,
      width: 5,
    ));
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          _infoBox("Duration", directionsResponse.routes[0].legs[0].duration.text),

        ],
      ),
    );
  }
  
  Widget _infoBox(String title, String info) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(title),
              Text(info),
            ],
          ),
        ),
      ),
    );
  }

  List<map.LatLng> _decodePoly(String poly) {
    var list = poly.codeUnits;
    var points = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      // if value is negative then bitwise not the value
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      points.add(result1);
    } while (index < len);

    // adding to previous value as done in encoding
    for (var i = 2; i < points.length; i++) points[i] += points[i - 2];

    // convert the points to latitude and longitude
    List<map.LatLng> result = [];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(map.LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

}