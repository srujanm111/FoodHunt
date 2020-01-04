import 'package:flutter/material.dart';
import 'package:food_hunt/panel_widgets.dart';
import 'package:food_hunt/recipe_panels.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PanelTab(),
        PanelHeader(title: "Sell Your Food", onClose: () {
          Controls.of(context).changePanel(MainPanel(MediaQuery.of(context).size.height));
        },),
        Container(
          height: MediaQuery.of(context).size.height * SellListPanel.scale - 80,
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
    for (Recipe recipe in recipes) {
      widgets.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: SellRecipeItem(recipe: recipe,),
        onTap: () {
          //Controls.of(context).changePanel(RecipeHuntPanel(recipe));
        },
      ));
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.removeLast();
    return widgets;
  }

}