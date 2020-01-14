import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt/base_page.dart';
import 'package:food_hunt/game_manager.dart';
import 'package:food_hunt/panel_widgets.dart';
import 'package:food_hunt/data_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'constants.dart';
import 'data_classes.dart';
import 'main_panel.dart';

class RecipesListPanel extends Panel {

  static final double scale = 0.7;

  RecipesListPanel(double screenHeight) : super(panelHeightOpen: screenHeight * scale, panelHeightClosed: 193);

  @override
  State createState() => _RecipesListPanelState();

}

class _RecipesListPanelState extends State<RecipesListPanel> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PanelTab(),
        PanelHeader(title: "Recipes", onClose: () {
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
    for (Recipe recipe in GameManager.instance.storedGameData.recipesToBeCompleted) {
      widgets.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: RecipeItem(recipe: recipe, isRecommended: true,),
        onTap: () {
          Controls.of(context).changePanel(RecipeHuntPanel(recipe));
        },
      ));
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.removeLast();
    return widgets;
  }

}

class RecipeHuntPanel extends Panel {

  final Recipe recipe;
  
  RecipeHuntPanel(this.recipe) : super(panelHeightClosed: 180, panelHeightOpen: 270.0 + recipe.ingredients.length * 50, isOpenByDefault: false);

  @override
  State createState() => _RecipesHuntPanelState();

}

class _RecipesHuntPanelState extends State<RecipeHuntPanel> {
  
  @override
  Widget build(BuildContext context) {
    _createMarkers();
    return Column(
      children: <Widget>[
        PanelTab(),
        Column(
          children: [
            PanelHeader(
              title: foodName[widget.recipe.food],
              subTitle: _sub(),
              actionButton: _button(),
              onClose: () {
                Controls.of(context).mapController.clearCircles();
                Controls.of(context).mapController.clearMarkers();
                Controls.of(context).changePanel(RecipesListPanel(MediaQuery.of(context).size.height));
              },
            ),
            SizedBox(height: 15,),
            ListHeader(
              title: "Ingredients",
              trailing: Text("${_ingredientsFoundCount()}/${widget.recipe.ingredients.length} Found", style: Theme.of(context).textTheme.caption,),
            ),
            Column(
              children: _ingredientList(),
            )
          ],
        ),
      ],
    );
  }

  void _createMarkers() {
    for (IngredientItem ingredientItem in widget.recipe.ingredients) {
      if (!ingredientItem.found) {
        Controls.of(context).mapController.createHintCircle(LatLng(ingredientItem.latitude, ingredientItem.longitude));
      }
      Controls.of(context).mapController.createMarker(
        Image(
          image: AssetImage('assets/icons/ingredients/${ingredientImageName[ingredientItem.ingredient]}'),
          height: 30,
          width: 30,
          color: white,
        ),
        MarkerId(GlobalKey().toString()),
        LatLng(ingredientItem.latitude, ingredientItem.longitude), null);
    }
  }

  Widget _sub() {
    return Row(
      children: <Widget>[
        Text("${sellLocationName[widget.recipe.sellLocation]} •", style: Theme.of(context).textTheme.subtitle,),
        Container(
            height: 24,
            width: 24,
            child: Image(image: AssetImage('assets/icons/money.png'), color: green,)
        ),
        Text(widget.recipe.sellPrice.toString(), style: Theme.of(context).textTheme.display1.apply(color: green),),
      ],
    );
  }

  Widget _button() {
    return CupertinoButton(
      color: primary,
      child: Text("Start Hunt"),
      onPressed: () {
        IngredientItem ingredient = Controls.of(context).startHunt(widget.recipe);
        Controls.of(context).changePanel(HuntPanel(widget.recipe, ingredient));
      },
    );
  }

  int _ingredientsFoundCount() {
    int count = 0;
    for (IngredientItem ingredientItem in widget.recipe.ingredients) {
      if (ingredientItem.found) {
        count++;
      }
    }
    return count;
  }

  List<Widget> _ingredientList() {
    List<Widget> widgets = [];
    for (IngredientItem ingredientItem in widget.recipe.ingredients) {
      widgets.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: IngredientListItem(ingredientItem),
        onTap: () {
          Controls.of(context).closePanel();
          Controls.of(context).mapController.animateTo(LatLng(ingredientItem.latitude, ingredientItem.longitude));
        },
      ),);
      widgets.add(ListDivider(edgePadding: 20,));
    }
    widgets.removeLast();
    return widgets;
  }

}


class HuntPanel extends Panel {

  final Recipe recipe;
  IngredientItem currentIngredient;

  HuntPanel(this.recipe, this.currentIngredient) : super(panelHeightClosed: 114, panelHeightOpen: 200.0 + recipe.ingredients.length * 50, isOpenByDefault: false);

  @override
  _HuntPanelState createState() => _HuntPanelState();
}

class _HuntPanelState extends State<HuntPanel> {

  StreamSubscription locationSubscription;

  @override
  void initState() {
    _startListening();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GameManager.instance.locationUtility.getCurrentPosition().then((position) {
      _createMarkers(position);
    });
    return Column(
      children: <Widget>[
        PanelTab(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(foodName[widget.recipe.food], style: Theme.of(context).textTheme.title,),
                  Row(
                    children: <Widget>[
                      Text("${sellLocationName[widget.recipe.sellLocation]} •", style: Theme.of(context).textTheme.subtitle,),
                      Container(
                          height: 24,
                          width: 24,
                          child: Image(image: AssetImage('assets/icons/money.png'), color: green,)
                      ),
                      Text(widget.recipe.sellPrice.toString(), style: Theme.of(context).textTheme.display1.apply(color: green),),
                    ],
                  )
                ],
              ),
              _actionButton(),
            ],
          ),
        ),
        SizedBox(height: 20,),
        ListDivider(),
        SizedBox(height: 15,),
        ListHeader(
          title: "Ingredients",
          trailing: Text("${_ingredientsFoundCount()}/${widget.recipe.ingredients.length} Found", style: Theme.of(context).textTheme.caption,),
        ),
        Column(
          children: _ingredientList(),
        )
      ],
    );
  }

  void _startListening() async {
    locationSubscription = GameManager.instance.locationUtility.getPositionStream().listen((position) {
      print('hi');
      if (position == null) return;
      GameManager.instance.locationUtility.distanceBetweenPoints(
        position.latitude,
        position.longitude,
        widget.currentIngredient.latitude,
        widget.currentIngredient.longitude).then(
      (dist) {
        Controls.of(context).updateInfoBar("${dist.toStringAsFixed(1)} mi");
      });
      setState(() {
        _createMarkers(position);
      });
    });
  }

  void _createMarkers(Position position) async {
    Controls.of(context).mapController.clearCircles();
    Controls.of(context).mapController.clearMarkers();
    for (IngredientItem ingredientItem in widget.recipe.ingredients) {
      double dist = await GameManager.instance.locationUtility.distanceBetweenPoints(
          position.latitude,
          position.longitude,
          ingredientItem.latitude,
          ingredientItem.longitude);
      if (dist < 10) continue;
      if (!ingredientItem.found) {
        Controls.of(context).mapController.createHintCircle(LatLng(ingredientItem.latitude, ingredientItem.longitude));
      }
      precacheImage(AssetImage('assets/icons/ingredients/${ingredientImageName[ingredientItem.ingredient]}'), context).then((x) {
        Controls.of(context).mapController.createMarker(
            Image(
              image: AssetImage('assets/icons/ingredients/${ingredientImageName[ingredientItem.ingredient]}'),
              height: 30,
              width: 30,
              color: white,
            ),
            MarkerId(GlobalKey().toString()),
            LatLng(ingredientItem.latitude, ingredientItem.longitude),
                () {
              if (!ingredientItem.found) {
                Controls.of(context).huntForIngredient(ingredientItem);
              }
            });
      });

    }
  }

  Widget _actionButton() {
    if (_isHuntDone()) {
      return _createButton("Finish", green, () {
        locationSubscription.cancel();
        Controls.of(context).mapController.clearMarkers();
        Controls.of(context).mapController.clearCircles();
      });
    } else {
      return _createButton("Exit", red, () {
        locationSubscription.cancel();
        Controls.of(context).mapController.clearMarkers();
        Controls.of(context).mapController.clearCircles();
        Controls.of(context).closeHunt();
        Controls.of(context).changePanel(RecipeHuntPanel(widget.recipe));
      });
    }
  }

  Widget _createButton(String text, Color color, Function onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(text, style: Theme.of(context).textTheme.title.apply(color: white),),
        ),
      ),
    );
  }

  bool _isHuntDone() {
    for (IngredientItem ingredientItem in widget.recipe.ingredients) {
      if (!ingredientItem.found) {
        return false;
      }
    }
    return true;
  }

  int _ingredientsFoundCount() {
    int count = 0;
    for (IngredientItem ingredientItem in widget.recipe.ingredients) {
      if (ingredientItem.found) {
        count++;
      }
    }
    return count;
  }

  List<Widget> _ingredientList() {
    List<Widget> widgets = [];
    for (IngredientItem ingredientItem in widget.recipe.ingredients) {
      widgets.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: IngredientListItem(ingredientItem),
        onTap: () {
          Controls.of(context).closePanel();
          Controls.of(context).mapController.animateTo(LatLng(ingredientItem.latitude, ingredientItem.longitude));
          if (!ingredientItem.found) {
            Controls.of(context).huntForIngredient(ingredientItem);
            GameManager.instance.locationUtility.getCurrentPosition().then((position) {
              setState(() {
                widget.currentIngredient = ingredientItem;
              });
              GameManager.instance.locationUtility.distanceBetweenPoints(
                position.latitude,
                position.longitude,
                widget.currentIngredient.latitude,
                widget.currentIngredient.longitude).then(
              (dist) {
                Controls.of(context).updateInfoBar("${dist.toStringAsFixed(1)} mi");
              });
            });
          }
        },
      ));
      widgets.add(ListDivider(edgePadding: 20,));
    }
    widgets.removeLast();
    return widgets;
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

}