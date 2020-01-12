import 'package:flutter/material.dart';
import 'package:food_hunt/base_page.dart';
import 'package:food_hunt/game_manager.dart';
import 'package:food_hunt/recipe_panels.dart';
import 'package:food_hunt/sell_panels.dart';
import 'package:food_hunt/social_panels.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';
import 'panel_widgets.dart';
import 'data_classes.dart';
import 'data_widgets.dart';

class MainPanel extends Panel {

  static final double scale = 0.8;

  MainPanel(double screenHeight) : super(panelHeightOpen: screenHeight * scale);

  @override
  _MainSheetState createState() => _MainSheetState();
}

class _MainSheetState extends State<MainPanel> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PanelTab(),
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
    List<Widget> widgets  = [];
    widgets.addAll(_recommendedRecipeHuntList());
    widgets.add(SizedBox(height: 10,));
    widgets.addAll(_foodToSellList());
    widgets.add(SizedBox(height: 10,));
    widgets.addAll(_friendsNearYouList());
    widgets.add(SizedBox(height: 20,));
    return widgets;
  }

  List<Widget> _recommendedRecipeHuntList() {
    List<Widget> widgets  = [];
    widgets.add(ListHeader(title: "Recommended Recipe Hunts", trailing: ListActionButton(title: "View All", onPress: () {
      Controls.of(context).changePanel(RecipesListPanel(MediaQuery.of(context).size.height));
    },),),);
    int i = 0;
    for (Recipe recipe in GameManager.instance.storedGameData.recipesToBeCompleted) {
      if (i == 3) break;
      widgets.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: RecommendedRecipeItem(recipe: recipe,),
        onTap: () {
          Controls.of(context).changePanel(RecipeHuntPanel(recipe));
          for (IngredientItem i in recipe.ingredients) {
            Controls.of(context).mapController.createMarker(
                Image(
                  image: AssetImage('assets/icons/ingredients/${ingredientImageName[i.ingredient]}'),
                  height: 30,
                  width: 30,
                  color: white,
                ),
                MarkerId(GlobalKey().toString()),
                LatLng(i.latitude, i.longitude),
                    () {});
          }
          Controls.of(context).mapController.clearMarkers();
        },
      ));
      widgets.add(ListDivider(edgePadding: 15,));
      i++;
    }
    widgets.removeLast();
    return widgets;
  }

  List<Widget> _foodToSellList() {
    List<Widget> widgets  = [];
    widgets.add(ListHeader(title: "Food To Sell", trailing: ListActionButton(title: "View All", onPress: () {
      Controls.of(context).changePanel(SellListPanel(MediaQuery.of(context).size.height));
    },),),);
    int i = 0;
    for (Recipe recipe in GameManager.instance.storedGameData.recipesToBeSold) {
      if (i == 3) break;
      widgets.add(SellPreviewItem(recipe: recipe,));
      widgets.add(ListDivider(edgePadding: 15,));
      i++;
    }
    widgets.removeLast();
    return widgets;
  }

  List<Widget> _friendsNearYouList() {
    List<Widget> widgets  = [];
    widgets.add(ListHeader(title: "Friends Near You", trailing: ListActionButton(title: "View All", onPress: () {
      Controls.of(context).changePanel(SocialListPanel(MediaQuery.of(context).size.height));
    },),),);
    int i = 0;
    for (Friend friend in GameManager.instance.storedGameData.friends) {
      if (i == 3) break;
      widgets.add(FriendsNearYouItem(friend: friend,));
      widgets.add(ListDivider(edgePadding: 15,));
      i++;
    }
    widgets.removeLast();
    return widgets;
  }

}