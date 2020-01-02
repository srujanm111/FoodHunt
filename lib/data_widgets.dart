import 'package:flutter/material.dart';
import 'constants.dart';
import 'data_classes.dart';

class RecommendedRecipeItem extends StatelessWidget {

  final Recipe recipe;

  RecommendedRecipeItem({
    @required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 55,
            width: 45,
            decoration: BoxDecoration(
              color: primaryFaded,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/food/${foodImageName[recipe.food]}'),
                color: primary,
                height: 37,
                width: 33.4,
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(foodName[recipe.food], style: Theme.of(context).textTheme.headline,),
              SizedBox(height: 4),
              Text("${ingredientsFoundCount()}/${recipe.ingredients.length} Ingredients Found", style: Theme.of(context).textTheme.caption,),
            ],
          )
        ],
      ),
    );
  }

  int ingredientsFoundCount() {
    int count = 0;
    for (IngredientItem ingredientItem in recipe.ingredients) {
      if (ingredientItem.found) {
        count++;
      }
    }
    return count;
  }

}

class SellPreviewItem extends StatelessWidget {

  final Recipe recipe;

  SellPreviewItem({
    @required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 55,
            width: 45,
            decoration: BoxDecoration(
              color: primaryFaded,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/food/${foodImageName[recipe.food]}'),
                color: primary,
                height: 37,
                width: 33.4,
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(foodName[recipe.food], style: Theme.of(context).textTheme.headline,),
              SizedBox(height: 4),
              Text("Sell at a ${sellLocationName[recipe.sellLocation]} place", style: Theme.of(context).textTheme.caption,),
            ],
          )
        ],
      ),
    );
  }

}

class FriendsNearYouItem extends StatelessWidget {

  final Friend friend;

  FriendsNearYouItem({
    @required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: (friend is RegisteredFriend) ? primary : lightGray,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text("dist"),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${friend.firstName} ${friend.lastName}", style: Theme.of(context).textTheme.headline,),
              SizedBox(height: 4),
              Text(_description(), style: Theme.of(context).textTheme.caption,),
            ],
          )
        ],
      ),
    );
  }

  String _description() {
    if (friend is RegisteredFriend) {
      if ((friend as RegisteredFriend).isInContacts) {
        return "In your contacts";
      } else {
        return "In game friend";
      }
    } else {
      return "In your contacts";
    }
  }

}

class RecipeItem extends StatelessWidget {

  final Recipe recipe;

  RecipeItem({
    @required this.recipe,
  });

  @override
  Widget build(BuildContext context) {

  }

}

class SellRecipeItem extends StatelessWidget {

  final Recipe recipe;

  SellRecipeItem({
    @required this.recipe,
  });

  @override
  Widget build(BuildContext context) {

  }

}

class FriendItem extends StatelessWidget {

  final Friend friend;

  FriendItem({
    @required this.friend,
  });

  @override
  Widget build(BuildContext context) {

  }

}