import 'package:flutter/material.dart';
import 'package:food_hunt/game_manager.dart';
import 'package:google_maps_webservice/places.dart';
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
  final bool isRecommended;

  RecipeItem({
    @required this.recipe,
    @required this.isRecommended
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 78,
            width: 60,
            decoration: BoxDecoration(
              color: primaryFaded,
              borderRadius: BorderRadius.circular(14)
            ),
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/food/${foodImageName[recipe.food]}'),
                color: primary,
                height: 48,
                width: 48,
              ),
            ),
          ),
          SizedBox(width: 20,),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _overHeadText(context),
                SizedBox(height: 4,),
                Text(foodName[recipe.food], style: Theme.of(context).textTheme.headline,),
                SizedBox(height: 8,),
                _sellValue(context),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              height: 75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text("${_ingredientsFoundCount()}/${recipe.ingredients.length} Ingredients", style: Theme.of(context).textTheme.caption,),
                  Row(
                    children: <Widget>[
                      Text(sellLocationName[recipe.sellLocation], style: Theme.of(context).textTheme.subtitle,),
                      SizedBox(width: 8,),
                      _sellLocationIcon(),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _overHeadText(BuildContext context) {
    if (isRecommended) {
      return Text("Recommended", style: Theme.of(context).textTheme.display1.apply(color: primary));
    } else if (_isIncomplete()) {
      return Text("Incomplete", style: Theme.of(context).textTheme.display1.apply(color: orange));
    } else {
      return Text("Not Started", style: Theme.of(context).textTheme.display1.apply(color: primary));
    }
  }

  bool _isIncomplete() {
    for (IngredientItem ingredientItem in recipe.ingredients) {
      if (ingredientItem.found) {
        return true;
      }
    }
    return false;
  }

  Widget _sellValue(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image(
          image: AssetImage('assets/icons/money.png'),
          color: green,
          height: 24,
          width: 24,
        ),
        Text(recipe.sellPrice.toString(), style: Theme.of(context).textTheme.display1.apply(color: green),)
      ],
    );
  }

  int _ingredientsFoundCount() {
    int count = 0;
    for (IngredientItem ingredientItem in recipe.ingredients) {
      if (ingredientItem.found) {
        count++;
      }
    }
    return count;
  }

  Widget _sellLocationIcon() {
    return Container(
      height: 33,
      width: 33,
      decoration: BoxDecoration(
        color: primary,
        shape: BoxShape.circle
      ),
      child: Center(
        child: Image(
          image: AssetImage('assets/icons/sell_categories/${sellLocationImageName[recipe.sellLocation]}'),
          color: white,
          height: 20,
          width: 20,
        ),
      ),
    );
  }

}

class SellRecipeItem extends StatelessWidget {

  final Recipe recipe;

  SellRecipeItem({
    @required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 65,
            width: 50,
            decoration: BoxDecoration(
                color: primaryFaded,
                borderRadius: BorderRadius.circular(14)
            ),
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/food/${foodImageName[recipe.food]}'),
                color: primary,
                height: 40,
                width: 40,
              ),
            ),
          ),
          SizedBox(width: 20,),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(foodName[recipe.food], style: Theme.of(context).textTheme.headline,),
                SizedBox(height: 8,),
                _sellValue(context),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: <Widget>[
                Text(sellLocationName[recipe.sellLocation], style: Theme.of(context).textTheme.subtitle,),
                SizedBox(width: 8,),
                _sellLocationIcon(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _sellValue(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image(
          image: AssetImage('assets/icons/money.png'),
          color: green,
          height: 24,
          width: 24,
        ),
        Text(recipe.sellPrice.toString(), style: Theme.of(context).textTheme.subtitle.apply(color: green),)
      ],
    );
  }

  Widget _sellLocationIcon() {
    return Container(
      height: 33,
      width: 33,
      decoration: BoxDecoration(
          color: primary,
          shape: BoxShape.circle
      ),
      child: Center(
        child: Image(
          image: AssetImage('assets/icons/sell_categories/${sellLocationImageName[recipe.sellLocation]}'),
          color: white,
          height: 20,
          width: 20,
        ),
      ),
    );
  }

}

class FriendItem extends StatelessWidget {

  final Friend friend;

  FriendItem({
    @required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          (friend is RegisteredFriend) ? _sellValue(context) : Container(),
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

  Widget _sellValue(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image(
          image: AssetImage('assets/icons/money.png'),
          color: green,
          height: 24,
          width: 24,
        ),
        Text((friend as RegisteredFriend).money.toString(), style: Theme.of(context).textTheme.subtitle.apply(color: green),)
      ],
    );
  }

}

class IngredientListItem extends StatefulWidget {

  final IngredientItem ingredientItem;

  IngredientListItem(this.ingredientItem);

  @override
  _IngredientListItemState createState() => _IngredientListItemState();
}
class _IngredientListItemState extends State<IngredientListItem> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          _ingredientIcon(),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(ingredientName[widget.ingredientItem.ingredient], style: Theme.of(context).textTheme.headline,),
              Text(_description(), style: Theme.of(context).textTheme.caption,),
            ],
          )
        ],
      ),
    );
  }

  Widget _ingredientIcon() {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: widget.ingredientItem.found ? primary : lightGray,
        shape: BoxShape.circle
      ),
      child: Center(
        child: Image(
          image: AssetImage('assets/icons/ingredients/${ingredientImageName[widget.ingredientItem.ingredient]}'),
          color: widget.ingredientItem.found ? white : darkGray,
          height: 24,
          width: 24,
        ),
      ),
    );
  }

  String _description() {
    if (widget.ingredientItem.found) {
      return "Found at Coordinates";
    } else {
      return "Area";
    }
  }

}

class SellLocationItem extends StatelessWidget {

  final PlacesSearchResult place;
  final double miles;

  SellLocationItem(this.place, this.miles);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(_photoURL(),).image,
                fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(14)
            ),
          ),
          SizedBox(width: 20,),
          Container(
            width: MediaQuery.of(context).size.width - 175,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(place.name, style: Theme.of(context).textTheme.headline, overflow: TextOverflow.fade,),
                SizedBox(height: 2,),
                _locationDetails(context),
                _ratingDetails(context)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: _sellLocationIcon(),
          )
        ],
      ),
    );
  }

  String _photoURL() {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place.photos[0].photoReference}&key=${GameManager.apiKey}";
  }

  Widget _locationDetails(BuildContext context) {
    return Text("${place.vicinity.substring(place.vicinity.indexOf(", ") + 2)} • ${miles.toStringAsFixed(2)} mi", style: Theme.of(context).textTheme.subtitle,);
  }

  Widget _ratingDetails(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          height: 16,
          width: 16,
          image: AssetImage("assets/icons/star.png"),
          color: yellow,
        ),
        Text("${place.rating} • ", style: Theme.of(context).textTheme.subtitle.apply(color: yellow),),
        Text("${_priceLevel()} bonus", style: Theme.of(context).textTheme.subtitle.apply(color: green),),
      ],
    );
  }

  String _priceLevel() {
    if (place.priceLevel == null) return "\$";
    String price = "\$";
    for (int i = 1; i < place.priceLevel.index; i++) {
      price += "\$";
    }
    return price;
  }

  Widget _sellLocationIcon() {
    return Container(
      height: 33,
      width: 33,
      decoration: BoxDecoration(
          color: primary,
          shape: BoxShape.circle
      ),
      child: Center(
        child: Image.network(
          place.icon,
          color: white,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {

  final Review review;

  ReviewItem(this.review);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _profilePhoto(),
        SizedBox(width: 20,),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(review.authorName, style: Theme.of(context).textTheme.subtitle,),
                  _ratingMeter()
                ],
              ),
              SizedBox(height: 10,),
              Container(
                child: Text(review.text),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _profilePhoto() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.network(review.profilePhotoUrl).image
        )
      ),
    );
  }

  Widget _ratingMeter() {
    List<Widget> stars = [];
    for (int i = 0; i < review.rating; i++) {
      stars.add(Image(
        height: 16,
        width: 16,
        image: AssetImage("assets/icons/star.png"),
        color: yellow,
      ));
    }
    for (int i = review.rating; i < 5; i++) {
      stars.add(Image(
        height: 16,
        width: 16,
        image: AssetImage("assets/icons/star.png"),
        color: lightGray,
      ));
    }
    return Row(
      children: stars,
    );
  }

}