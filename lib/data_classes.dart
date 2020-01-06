import 'constants.dart';

class Recipe {

  final String _foodId = "food";
  final String _sellPriceId = "sellPrice";
  final String _sellLocationId = "sellLocation";
  final String _ingredientsId = "ingredients";

  Food _food;
  int _sellPrice;
  SellLocation _sellLocation;
  List<IngredientItem> _ingredients;

  Recipe(
      this._food, this._sellPrice, this._sellLocation, this._ingredients);

  Recipe.fromJson(Map<String, dynamic> json) {
    _food = nameFood[json[_foodId]];
    _sellPrice = json[_sellPriceId];
    _sellLocation = nameSellLocation[_sellLocationId];
    _ingredients = (json[_ingredientsId] as List).map((i) => IngredientItem.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() => {
    _foodId : foodName[_food],
    _sellPriceId : _sellPrice,
    _sellLocationId : sellLocationName[_sellLocation],
    _ingredientsId : _ingredients
  };

  List<IngredientItem> get ingredients => _ingredients;

  SellLocation get sellLocation => _sellLocation;

  int get sellPrice => _sellPrice;

  Food get food => _food;
}

class IngredientItem {

  String _ingredientId = "ingredient";
  String _latitudeId = "latitude";
  String _longitudeId = "longitude";
  String _foundId = "found";

  Ingredient _ingredient;
  double _latitude;
  double _longitude;
  bool _found;

  IngredientItem(
      this._ingredient, this._latitude, this._longitude, this._found);

  IngredientItem.fromJson(Map<String, dynamic> json) {
    _ingredient = nameIngredient[json[_ingredientId]];
    _latitude = json[_latitudeId];
    _longitude = json[_longitudeId];
    _found = json[_foundId];
  }

  Map<String, dynamic> toJson() => {
    _ingredientId : _ingredient,
    _latitudeId : _latitude,
    _longitudeId : _longitude,
    _foundId : _found,
  };

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
}

abstract class Friend {

  String _firstName;
  String _lastName;

  Friend(this._firstName, this._lastName);

  String get lastName => _lastName;

  String get firstName => _firstName;

  static Friend fromJson(Map<String, dynamic> json) {
    if (json.keys.length == 7) {
      return RegisteredFriend.fromJson(json);
    } else {
      return UnregisteredFriend.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}

class RegisteredFriend extends Friend {

  String _moneyId = "money";
  String _latitudeId = "latitude";
  String _longitudeId = "longitude";
  String _phoneNumberId = "phoneNumber";
  String _isInContactsId = "isInContacts";

  int _money;
  double _latitude;
  double _longitude;
  String _phoneNumber;
  bool _isInContacts;

  RegisteredFriend(String firstName, String lastName, this._money, this._latitude, this._longitude,
      this._phoneNumber, this._isInContacts) : super(firstName, lastName);

  RegisteredFriend.fromJson(Map<String, dynamic> json) : super(json["firstName"], json["lastName"]) {
    _money = json[_moneyId];
    _latitude = json[_latitudeId];
    _longitude = json[_longitudeId];
    _phoneNumber = json[_phoneNumberId];
    _isInContacts = json[_isInContactsId];
  }

  Map<String, dynamic> toJson() => {
    "firstName" : _firstName,
    "lastName" : _lastName,
    _moneyId : _money,
    _latitudeId : _latitude,
    _longitudeId : _longitude,
    _phoneNumberId : _phoneNumber,
    _isInContactsId : _isInContacts,
  };

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

  UnregisteredFriend.fromJson(Map<String, dynamic> json) : super(json["firstName"], json["lastName"]) {
    _areaCode = json[_areaCodeId];
  }

  Map<String, dynamic> toJson() => {
    "firstName" : _firstName,
    "lastName" : _lastName,
    _areaCodeId : _areaCode
  };

  String get areaCode => _areaCode;
}