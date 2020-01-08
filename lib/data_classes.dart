import 'package:food_hunt/database.dart';

import 'constants.dart';

class Recipe {

  int id;
  Food _food;
  int _sellPrice;
  SellLocation _sellLocation;
  List<IngredientItem> ingredients;

  Recipe(
      this._food, this._sellPrice, this._sellLocation, this.ingredients);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      foodLabel: foodName[_food],
      sellPriceLabel: _sellPrice,
      sellLocationLabel: sellLocationName[_sellLocation],
    };
    if (id != null) {
      map[idLabel] = id;
    }
    return map;
  }

  Recipe.fromMap(Map<String, dynamic> map) {
    id = map[idLabel];
    _food = nameFood[map[foodLabel]];
    _sellPrice = map[sellPriceLabel];
    _sellLocation = nameSellLocation[map[sellLocationLabel]];
  }
  
  SellLocation get sellLocation => _sellLocation;

  int get sellPrice => _sellPrice;

  Food get food => _food;
}

class IngredientItem {

  int id;
  Ingredient _ingredient;
  double _latitude;
  double _longitude;
  bool _found;

  IngredientItem(
      this._ingredient, this._latitude, this._longitude, this._found);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      ingredientLabel: ingredientName[_ingredient],
      latitudeLabel: _latitude,
      longitudeLabel: _longitude,
      isFoundLabel: _found ? 1 : 0,
    };
    if (id != null) {
      map[idLabel] = id;
    }
    return map;
  }

  IngredientItem.fromMap(Map<String, dynamic> map) {
    id = map[idLabel];
    _ingredient = nameIngredient[map[ingredientLabel]];
    _latitude = map[latitudeLabel];
    _longitude = map[longitudeLabel];
    _found = map[isFoundLabel] == 1;
  }

  bool get found => _found;

  double get longitude => _longitude;

  double get latitude => _latitude;

  Ingredient get ingredient => _ingredient;

  void setFound() {
    _found = true;
  }
}

class User {

  String _phoneNumber;
  String _firstName;
  String _lastName;
  String _password;
  int _money;

  User(this._phoneNumber, this._firstName, this._lastName, this._password, this._money);

  String get password => _password;

  String get lastName => _lastName;

  String get firstName => _firstName;

  String get phoneNumber => _phoneNumber;

  int get money => _money;
}

abstract class Friend {

  String _firstName;
  String _lastName;

  Friend(this._firstName, this._lastName);

  String get lastName => _lastName;

  String get firstName => _firstName;
}

class RegisteredFriend extends Friend {

  int id;
  int _money;
  double _latitude;
  double _longitude;
  String _phoneNumber;
  bool _isInContacts;

  RegisteredFriend(String firstName, String lastName, this._money, this._latitude, this._longitude,
      this._phoneNumber, this._isInContacts) : super(firstName, lastName);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      latitudeLabel: _latitude,
      longitudeLabel: _longitude,
      phoneNumberLabel: _phoneNumber,
      isInContactsLabel: _isInContacts ? 1 : 0,
      firstNameLabel: _firstName,
      lastNameLabel: _lastName
    };
    if (id != null) {
      map[idLabel] = id;
    }
    return map;
  }

  RegisteredFriend.fromMap(Map<String, dynamic> map) : super(map[firstNameLabel], map[lastNameLabel]) {
    id = map[idLabel];
    _phoneNumber = map[phoneNumberLabel];
    _latitude = map[latitudeLabel];
    _longitude = map[longitudeLabel];
    _isInContacts = map[isInContacts] == 1;
  }

  bool get isInContacts => _isInContacts;

  String get phoneNumber => _phoneNumber;

  double get longitude => _longitude;

  double get latitude => _latitude;

  int get money => _money;
}

class UnregisteredFriend extends Friend {

  String _areaCodeId = "areaCode";

  String _areaCode;

  UnregisteredFriend(String firstName, String lastName, this._areaCode) : super(firstName, lastName);

  String get areaCode => _areaCode;
}