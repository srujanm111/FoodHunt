import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt/custom_panel_widgets.dart';
import 'package:food_hunt/data_widgets.dart';

import 'base_page.dart';
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
        Container(
          height: MediaQuery.of(context).size.height * RecipesListPanel.scale - 80,
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
    widgets.add(
      PanelHeader(title: "Recipes", onClose: () {
        Controls.of(context).changePanel(MainPanel(MediaQuery.of(context).size.height));
      },)
    );
    for (Recipe recipe in recipes) {
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
  
  RecipeHuntPanel(this.recipe) : super(panelHeightClosed: 180, panelHeightOpen: 270.0 + recipe.ingredients.length * 50);

  @override
  State createState() => _RecipesHuntPanelState();

}

class _RecipesHuntPanelState extends State<RecipeHuntPanel> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PanelTab(),
        Column(
          children: [
            PanelHeader(
              title: foodName[widget.recipe.food],
              subTitle: _sub(context),
              actionButton: _button(),
              onClose: () {
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

  Widget _sub(BuildContext context) {
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
      onPressed: () {},
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
      widgets.add(IngredientListItem(ingredientItem));
      widgets.add(ListDivider(edgePadding: 20,));
    }
    widgets.removeLast();
    return widgets;
  }

}