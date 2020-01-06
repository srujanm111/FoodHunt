import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constants.dart';
import 'data_classes.dart';

class GameManager {

  static GameManager _instance;

  _LocationUtility _locationUtility;
  _RecipeUtility _recipeUtility;
  _StoredGameData _storedGameData;
  _GameDataFileManager _gameDataFileManager;
  _FriendsUtility _friendsUtility;

  GameManager._internal() {
    _locationUtility = _LocationUtility(Geolocator(), LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10));
    _recipeUtility = _RecipeUtility();
    _friendsUtility = _FriendsUtility();
  }

  Future<void> requestPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
    // if PermissionStatus.denied, quit app
  }

  Future<void> initStoredGameData() async {
    _gameDataFileManager = await _GameDataFileManager.init();
    bool firstUse = await isFirstUse();
    if (firstUse) {
      Position position = await _locationUtility.getCurrentPosition();
      List<Recipe> recipes = await _recipeUtility.generateRecipes(position, 10);
      List<Friend> friends = await _friendsUtility.getFriends();
      _storedGameData = _StoredGameData(position, recipes, friends);
    } else {
      _storedGameData = _StoredGameData.fromJson(_gameDataFileManager.readJSON());
    }
  }

  Future<bool> isFirstUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isFirstUse") == null || prefs.getBool("isFirstUse") == true) {
      prefs.setBool("isFirstUse", false);
      return true;
    }
    return true; //change back later
  }

  Future<void> updateRecipeList() async {
    Position current = await _locationUtility.getCurrentPosition();
    Position previous = _storedGameData.startPosition;
    double distance = await _locationUtility.distanceBetweenPoints(current.latitude, current.longitude, previous.longitude, previous.longitude);
    if (distance > 100) {
      _storedGameData.recipesToBeCompleted.clear();
      List<Recipe> newRecipes = await _recipeUtility.generateRecipes(current, 10);
      _storedGameData.recipesToBeCompleted.addAll(newRecipes);
    } else if (_storedGameData.recipesToBeCompleted.length < 10) {
      List<Recipe> newRecipes = await _recipeUtility.generateRecipes(current, 10 - _storedGameData.recipesToBeCompleted.length);
      _storedGameData.recipesToBeCompleted.addAll(newRecipes);
    }
    _storedGameData.startPosition = await _locationUtility.getCurrentPosition();
  }

  static GameManager get instance {
    if (_instance == null) {
      _instance = GameManager._internal();
    }
    return _instance;
  }

  _LocationUtility get locationUtility => _locationUtility;

  _StoredGameData get storedGameData => _storedGameData;
}

class _GameDataFileManager {

  File _gameDataJSON;

  _GameDataFileManager(this._gameDataJSON);

  static Future<_GameDataFileManager> init() async {
    File gameDataFile = await getGameDataFile();
    return _GameDataFileManager(gameDataFile);
  }

  static Future<File> getGameDataFile() async {
    String fileName = "game_data.json";
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonData = new File(dir.path + "/" + fileName);
    if (!jsonData.existsSync()) {
      jsonData.createSync();
    }
    return jsonData;
  }

  void writeJSON(Map<String, dynamic> data) {
    _gameDataJSON.writeAsStringSync(json.encode(data));
  }

  Map<String, dynamic> readJSON() {
    return json.decode(_gameDataJSON.readAsStringSync());
  }

}

class _StoredGameData {
  
  final String _positionId = "position";
  final String _recipesToCompleteId = "recipesToBeCompleted";
  final String _recipesToSellId = "recipesToBeSold";
  final String _friendsId = "friends";

  Position startPosition;
  List<Recipe> _recipesToBeCompleted;
  List<Recipe> _recipesToBeSold;
  List<Friend> _friends;

  _StoredGameData(Position position, List<Recipe> recipes, List<Friend> friends) {
    _recipesToBeCompleted = [];
    _recipesToBeSold = [];
    startPosition = position;
    _friends = friends;
    for (Recipe recipe in recipes) {
      bool completed = true;
      for (IngredientItem ingredientItem in recipe.ingredients) {
        if (!ingredientItem.found) {
          completed = false;
          break;
        }
      }
      if (completed) {
        recipesToBeSold.add(recipe);
      } else {
        recipesToBeCompleted.add(recipe);
      }
    }
  }

  _StoredGameData.fromJson(Map<String, dynamic> json) {
    startPosition = Position.fromMap(json[_positionId]);
    _recipesToBeCompleted = (json[_recipesToCompleteId] as List).map((i) => Recipe.fromJson(i)).toList();
    _recipesToBeSold = (json[_recipesToSellId] as List).map((i) => Recipe.fromJson(i)).toList();
    _friends = (json[_friendsId] as List).map((i) => Friend.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() => {
    _positionId : startPosition,
    _recipesToCompleteId : _recipesToBeCompleted,
    _recipesToSellId : _recipesToBeSold,
    _friendsId : _friends,
  };

  List<Friend> get friends => _friends;

  List<Recipe> get recipesToBeSold => _recipesToBeSold;

  List<Recipe> get recipesToBeCompleted => _recipesToBeCompleted;

}

class _LocationUtility {

  Geolocator _geolocator;
  LocationOptions _locationOptions;

  _LocationUtility(this._geolocator, this._locationOptions);

  Future<Position> getCurrentPosition() async {
    Position position = await _geolocator.getCurrentPosition(desiredAccuracy: _locationOptions.accuracy);
    return position;
  }

  Stream<Position> getPositionStream() {
    return _geolocator.getPositionStream(_locationOptions);
//    .listen((Position position) {
//      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
//    }); <- StreamSubscription
  }

  Future<List<Placemark>> placeMarkFromAddress(String address) async {
    return await _geolocator.placemarkFromAddress(address);
  }

  Future<List<Placemark>> placeMarkFromCoordinates(double latitude, double longitude) async {
    return await _geolocator.placemarkFromCoordinates(latitude, longitude);
  }

  Future<double> distanceBetweenPoints(double latitude1, double longitude1, double latitude2, double longitude2) async {
    return await _geolocator.distanceBetween(latitude1, longitude1, latitude2, longitude2);
  }

}

class _RecipeUtility {

  Future<List<Recipe>> generateRecipes(Position position, int count) async {
    List<Recipe> recipes = [];
    for (int i = 0; i < count; i++) {
      recipes.add(Recipe(Food.sandwich, 20, SellLocation.restaurant, [
        IngredientItem(Ingredient.bread, position.latitude + 2, position.longitude, true),
        IngredientItem(Ingredient.tomato, position.latitude + 4, position.longitude, true),
        IngredientItem(Ingredient.lettuce, position.latitude + 6, position.longitude, false),
        IngredientItem(Ingredient.cheese, position.latitude + 8, position.longitude, false),
        IngredientItem(Ingredient.turkey, position.latitude + 10, position.longitude, false),
      ]));
    }
    for (int i = 0; i < 2; i++) {
      recipes.add(Recipe(Food.sandwich, 20, SellLocation.restaurant, [
        IngredientItem(Ingredient.bread, position.latitude + 2, position.longitude, true),
        IngredientItem(Ingredient.tomato, position.latitude + 4, position.longitude, true),
        IngredientItem(Ingredient.lettuce, position.latitude + 6, position.longitude, true),
        IngredientItem(Ingredient.cheese, position.latitude + 8, position.longitude, true),
        IngredientItem(Ingredient.turkey, position.latitude + 10, position.longitude, true),
      ]));
    }
    return recipes;
  }

  List<PlaceDetails> _getNearbyLocations(Position position) {}

  List<PlaceDetails> _chooseIngredients(int count) {}

}

class _FriendsUtility {

    Future<List<Contact>> _getContacts() async {
      return (await ContactsService.getContacts(withThumbnails: false)).toList();
    }

    Future<List<Friend>> getFriends() async {
      List<Friend> friends = [];
      List<Contact> contacts = await _getContacts();
      for (Contact contact in contacts) {
        List<Item> phoneNumberItems = contact.phones.toList();
        // check if contact exists in firestore and check which number exists
        friends.add(UnregisteredFriend(contact.givenName, contact.familyName, "hi"));
      }
      return friends;
    }

}