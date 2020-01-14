import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:food_hunt/data_widgets.dart';
import 'package:food_hunt/main_panel.dart';
import 'package:food_hunt/base_page.dart';
import 'package:food_hunt/map.dart';
import 'package:food_hunt/recipe_panels.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';
import 'data_classes.dart';

class BasePage extends StatefulWidget {

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> with SingleTickerProviderStateMixin {

  AnimationController _panelAnimationController;
  FoodHuntMapController _foodHuntMapController;
  
  Panel _currentPanel;
  DisplayBar _displayBar;
  InfoBar _infoBar;

  @override
  void initState(){
    super.initState();
    _panelAnimationController = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: 1 //set the default panel state
    )..addListener(() {
        setState(() {});
    });
    _foodHuntMapController = new FoodHuntMapController();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPanel == null) {
      _currentPanel = MainPanel(MediaQuery.of(context).size.height);
    }
    return Scaffold(
      appBar: _displayBar,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          //make the back widget take up the entire back side
          _body(),
          //the backdrop to overlay on the body
          Container(),
          //the actual sliding part
          _panel(),
          _infoBar != null ? _createInfoBar() : Container(),
        ],
      ),
    );
  }

  Widget _panel() {
    return GestureDetector(
      onVerticalDragUpdate: _onDrag,
      onVerticalDragEnd: _onDragEnd,
      child: Container(
        height: _panelAnimationController.value * _currentPanel.panelHeightOpen,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 8.0,
              color: Color.fromRGBO(0, 0, 0, 0.25),
            )
          ],
          color: white,
        ),
        child: Stack(
          children: <Widget>[
            //open panel
            Positioned(
                top: 0,
                width:  MediaQuery.of(context).size.width,
                child: Container(
                  height: _currentPanel.panelHeightOpen,
                  child: _createPanelContents(),
                )
            ),
            // collapsed panel
            Positioned(
              top: 0.0,
              width:  MediaQuery.of(context).size.width,
              child: Container(
                height: _currentPanel.panelHeightClosed,
                child: Opacity(
                  opacity: 1.0 - _panelAnimationController.value,
                  // if the panel is open ignore pointers (touch events) on the collapsed
                  // child so that way touch events go through to whatever is underneath
                  child: IgnorePointer(
                    ignoring: _panelAnimationController.value == 1,
                    child: Container(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createPanelContents() {
    return Controls(
      changePanel: _changePanelContents,
      startHunt: _startHunt,
      huntForIngredient: _huntForIngredient,
      closeHunt: _closeHunt,
      mapController: _foodHuntMapController,
      child: _currentPanel,
      closePanel: _closePanel,
      openPanel: _openPanel,
      updateInfoBar: _updateInfoBar,
    );
  }

  Widget _body() {
    return Positioned(
      top: 0.0,
      child: FoodHuntMap(
        controller: _foodHuntMapController,
      ),
    );
  }

  void _changePanelContents(Widget panel) {
    _panelAnimationController.fling(velocity: -1.0).then((x) {
      setState(() {
        _currentPanel = panel;
      });
      if (_currentPanel.isOpenByDefault) {
        _panelAnimationController.fling(velocity: 1.0);
      } else {
        _panelAnimationController.animateTo(_closedRatio());
      }
    });
  }

  void _closePanel() {
    _panelAnimationController.animateTo(_closedRatio());
  }

  void _openPanel() {
    _panelAnimationController.fling(velocity: 1.0);
  }

  IngredientItem _startHunt(Recipe recipe) {
    // replace with ingredient closest to current location
    for (IngredientItem ingredientItem in recipe.ingredients) {
      if (!ingredientItem.found) {
        _huntForIngredient(ingredientItem);
        return ingredientItem;
      }
    }
  }

  void _updateInfoBar(String text) {
    print('hiho');
    setState(() {
      _infoBar = InfoBar(
          Text(text, style: TextStyle(fontSize: 21, color: white),)
      );
    });
  }

  void _huntForIngredient(IngredientItem ingredient) {
    _displayBar = DisplayBar(
      icon: Container(
          height: 40,
          width: 40,
          child: Image(image: AssetImage('assets/icons/ingredients/${ingredientImageName[ingredient.ingredient]}'), color: white,)
      ),
      text: Text("Hunting For ${ingredientName[ingredient.ingredient]}", style: TextStyle(fontSize: 26, color: white, fontWeight: FontWeight.w700),),
    );
    _infoBar = InfoBar(
      Text("Distance", style: TextStyle(fontSize: 21, color: white),)
    );
    setState(() {});
  }

  void _closeHunt() {
    _displayBar = null;
    _infoBar = null;
  }

  Widget _createInfoBar() {
    return Positioned(
      top: 10,
      left: 15,
      child: _infoBar,
    );
  }

  @override
  void dispose(){
    _panelAnimationController.dispose();
    super.dispose();
  }

  void _onDrag(DragUpdateDetails details){
    _panelAnimationController.value -= details.primaryDelta / _currentPanel.panelHeightOpen;
  }

  void _onDragEnd(DragEndDetails details){
    double minFlingVelocity = 365.0;

    //let the current animation finish before starting a new one
    if(_panelAnimationController.isAnimating) return;

    //check if the velocity is sufficient to constitute fling
    if(details.velocity.pixelsPerSecond.dy.abs() >= minFlingVelocity){
      double visualVelocity = - details.velocity.pixelsPerSecond.dy / _currentPanel.panelHeightOpen;

      _panelAnimationController.animateTo(visualVelocity < 0 ? _closedRatio() : 1);

      return;
    }

    // check if the controller is already halfway there
    if(_panelAnimationController.value > 0.6)
      _panelAnimationController.fling(velocity: 1.0);
    else
      _panelAnimationController.animateTo(_closedRatio());
  }

  double _closedRatio() {
    return _currentPanel.panelHeightClosed / _currentPanel.panelHeightOpen;
  }

}

class Controls extends InheritedWidget {

  final FoodHuntMapController mapController;
  final Function(Panel panel) changePanel;
  final IngredientItem Function(Recipe recipe) startHunt;
  final Function(IngredientItem ingredient) huntForIngredient;
  final VoidCallback closeHunt;
  final VoidCallback closePanel;
  final VoidCallback openPanel;
  final Function(String text) updateInfoBar;

  Controls({
    @required this.changePanel,
    @required this.startHunt,
    @required this.huntForIngredient,
    @required this.closeHunt,
    @required this.mapController,
    @required this.closePanel,
    @required this.openPanel,
    @required this.updateInfoBar,
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

class DisplayBar extends StatelessWidget implements PreferredSizeWidget {

  final Widget icon;
  final Widget text;

  DisplayBar({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      color: primary,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              SizedBox(width: 15,),
              text,
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class InfoBar extends StatelessWidget {

  final Widget text;

  InfoBar(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF7582FB),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Center(
        child: text,
      ),
    );
  }


}