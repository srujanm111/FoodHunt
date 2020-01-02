import 'constants.dart';
import 'package:phone_number/phone_number.dart';

class Recipe {

  Food _food;
  int _sellPrice;
  SellLocation _sellLocation;
  List<IngredientItem> _ingredients;

  Recipe(
      this._food, this._sellPrice, this._sellLocation, this._ingredients);

  IngredientItem ingredients(int index) => _ingredients[index];

  SellLocation get sellLocation => _sellLocation;

  int get sellPrice => _sellPrice;

  Food get food => _food;
}

class IngredientItem {

  Ingredient _ingredient;
  double _latitude;
  double _longitude;
  bool _found;

  IngredientItem(
      this._ingredient, this._latitude, this._longitude, this._found);

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

  User(this._phoneNumber, this._firstName, this._lastName, this._password);

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
}

class RegisteredFriend extends Friend {

  int _money;
  double _latitude;
  double _longitude;
  String _phoneNumber;
  bool _isInContacts;

  RegisteredFriend(String firstName, String lastName, this._money, this._latitude, this._longitude,
      this._phoneNumber, this._isInContacts) : super(firstName, lastName);

  bool get isInContacts => _isInContacts;

  String get phoneNumber => _phoneNumber;

  double get longitude => _longitude;

  double get latitude => _latitude;

  int get money => _money;
}

class UnregisteredFriend extends Friend {

  String _areaCode;

  UnregisteredFriend(String firstName, String lastName, this._areaCode) : super(firstName, lastName);

  String get areaCode => _areaCode;
}