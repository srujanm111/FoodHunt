import 'package:flutter/material.dart';
import 'package:food_hunt/base_page.dart';
import 'package:food_hunt/recipe_panels.dart';

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

  List<Recipe> recipes = [
    Recipe(Food.sandwich, 20, SellLocation.restaurant, [
      IngredientItem(Ingredient.bread, 20, 20, true),
      IngredientItem(Ingredient.tomato, 20, 20, true),
      IngredientItem(Ingredient.lettuce, 20, 20, false),
      IngredientItem(Ingredient.cheese, 20, 20, false),
      IngredientItem(Ingredient.turkey, 20, 20, false),
    ]),
    Recipe(Food.sandwich, 20, SellLocation.restaurant, [
      IngredientItem(Ingredient.bread, 20, 20, true),
      IngredientItem(Ingredient.tomato, 20, 20, true),
      IngredientItem(Ingredient.lettuce, 20, 20, false),
      IngredientItem(Ingredient.cheese, 20, 20, false),
      IngredientItem(Ingredient.turkey, 20, 20, false),
    ]),
    Recipe(Food.sandwich, 20, SellLocation.restaurant, [
      IngredientItem(Ingredient.bread, 20, 20, true),
      IngredientItem(Ingredient.tomato, 20, 20, true),
      IngredientItem(Ingredient.lettuce, 20, 20, false),
      IngredientItem(Ingredient.cheese, 20, 20, false),
      IngredientItem(Ingredient.turkey, 20, 20, false),
    ]),
    Recipe(Food.sandwich, 20, SellLocation.restaurant, [
      IngredientItem(Ingredient.bread, 20, 20, true),
      IngredientItem(Ingredient.tomato, 20, 20, true),
      IngredientItem(Ingredient.lettuce, 20, 20, false),
      IngredientItem(Ingredient.cheese, 20, 20, false),
      IngredientItem(Ingredient.turkey, 20, 20, false),
    ]),
  ];

  List<Friend> friends = [
    RegisteredFriend("Kamal", "Jana", 20, 20, 20, "000-000-0000", true),
    RegisteredFriend("Kamal", "Jana", 20, 20, 20, "000-000-0000", true),
    RegisteredFriend("Kamal", "Jana", 20, 20, 20, "000-000-0000", true),
    RegisteredFriend("Kamal", "Jana", 20, 20, 20, "000-000-0000", true),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PanelTab(),
        Container(
          height: MediaQuery.of(context).size.height * MainPanel.scale - 25,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: _fullContents(context),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _fullContents(BuildContext context) {
    List<Widget> widgets  = [];
    widgets.addAll(_recommendedRecipeHuntList(context));
    widgets.add(SizedBox(height: 10,));
    widgets.addAll(_foodToSellList());
    widgets.add(SizedBox(height: 10,));
    widgets.addAll(_friendsNearYouList());
    widgets.add(SizedBox(height: 20,));
    return widgets;
  }

  List<Widget> _recommendedRecipeHuntList(BuildContext context) {
    List<Widget> widgets  = [];
    widgets.add(ListHeader(title: "Recommended Recipe Hunts", trailing: ListActionButton(title: "View All", onPress: () {
      Controls.of(context).changePanel(RecipesListPanel(MediaQuery.of(context).size.height));
    },),),);
    for (Recipe recipe in recipes) {
      widgets.add(RecommendedRecipeItem(recipe: recipe,));
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.removeLast();
    return widgets;
  }

  List<Widget> _foodToSellList() {
    List<Widget> widgets  = [];
    widgets.add(ListHeader(title: "Food To Sell", trailing: ListActionButton(title: "View All", onPress: () {},),),);
    for (Recipe recipe in recipes) {
      widgets.add(SellPreviewItem(recipe: recipe,));
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.removeLast();
    return widgets;
  }

  List<Widget> _friendsNearYouList() {
    List<Widget> widgets  = [];
    widgets.add(ListHeader(title: "Friends Near You", trailing: ListActionButton(title: "View All", onPress: () {},),),);
    for (Friend friend in friends) {
      widgets.add(FriendsNearYouItem(friend: friend,));
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.removeLast();
    return widgets;
  }

}