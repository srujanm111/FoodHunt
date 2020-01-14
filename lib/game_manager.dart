import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants.dart';
import 'data_classes.dart';
import 'database.dart';

class GameManager {

  static const String apiKey = 'AIzaSyAI4tTbcJYVABnw7tJ4iP-Sx4EFyRadrAo';

  static GameManager _instance;

  _LocationUtility _locationUtility;
  _RecipeUtility _recipeUtility;
  _StoredGameData _storedGameData;
  GameDatabaseManager _gameDatabaseManager;
  _FriendsUtility _friendsUtility;
  GoogleMapsPlaces _googleMapsPlaces;
  GoogleMapsDirections _googleMapsDirections;
  Firestore _firestore;

  GameManager._internal() {
    _locationUtility = _LocationUtility(Geolocator(), LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10));
    _recipeUtility = _RecipeUtility();
    _firestore = Firestore.instance;

  }

  Future<void> setUpManager() async {
    await _requestPermissions();
    await initGameData();
    await updateRecipeList();
  }

  Future<void> _initGoogleMapsServices() async {
    _googleMapsPlaces = new GoogleMapsPlaces(apiKey: GameManager.apiKey);
    _googleMapsDirections = new GoogleMapsDirections(apiKey: GameManager.apiKey);
  }

  Future<void> _initFriendsUtility() async {
    _friendsUtility = await _FriendsUtility.init();
  }

  Future<void> _requestPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
    if (permissions[PermissionGroup.contacts] == PermissionStatus.denied) {
      // quit app
    }
  }

  Future<void> initGameData() async {
    await _initGoogleMapsServices();
    await _initFriendsUtility();
    await _initGameDatabaseManager();
    bool firstUse = await isFirstUse();
    if (firstUse) {
      _storedGameData = await _createNewGameData();
      _storeGameData();
    } else {
      _storedGameData = await _getGameDataFromPersisted();
    }
  }

  Future<_StoredGameData> _getGameDataFromPersisted() async {
    Position position = await _locationUtility.getCurrentPosition();
    List<Recipe> recipes = await _gameDatabaseManager.getRecipes();
    List<Friend> friends = await _gameDatabaseManager.getFriends();
    return _StoredGameData(position, recipes, friends);
  }
  
  Future<_StoredGameData> _createNewGameData() async {
    Position position = await _locationUtility.getCurrentPosition();
    List<Recipe> recipes = await _recipeUtility.generateRecipes(position, 10);
    List<Friend> friends = _friendsUtility.registeredFriends;
    return _StoredGameData(position, recipes, friends);
  }

  Future<void> _storeGameData() async {
    for (Recipe recipe in _storedGameData.recipesToBeCompleted) {
      await _gameDatabaseManager.upsertRecipe(recipe, false);
      for (IngredientItem ingredientItem in recipe.ingredients) {
        await _gameDatabaseManager.upsertIngredientItem(ingredientItem, recipe.id);
      }
    }
    for (Recipe recipe in _storedGameData.recipesToBeSold) {
      await _gameDatabaseManager.upsertRecipe(recipe, true);
      for (IngredientItem ingredientItem in recipe.ingredients) {
        await _gameDatabaseManager.upsertIngredientItem(ingredientItem, recipe.id);
      }
    }
    for (RegisteredFriend friend in _storedGameData.friends) {
      await _gameDatabaseManager.upsertFriend(friend);
    }
  }

  Future<void> _initGameDatabaseManager() async {
    _gameDatabaseManager = await GameDatabaseManager.init();
  }

  Future<bool> isFirstUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isFirstUse") == null || prefs.getBool("isFirstUse") == true) {
      prefs.setBool("isFirstUse", false);
      return true;
    }
    return false;
  }

  Future<void> updateRecipeList() async {
    if (_storedGameData.recipesToBeCompleted.length < 10) {
      Position current = await _locationUtility.getCurrentPosition();
      List<Recipe> newRecipes = await _recipeUtility.generateRecipes(current, 10 - _storedGameData.recipesToBeCompleted.length);
      for (Recipe recipe in newRecipes) {
        _storedGameData.recipesToBeCompleted.add(recipe);
        _gameDatabaseManager.upsertRecipe(recipe, false);
      }
    }
  }

  static GameManager get instance {
    if (_instance == null) {
      _instance = GameManager._internal();
    }
    return _instance;
  }

  _LocationUtility get locationUtility => _locationUtility;

  _StoredGameData get storedGameData => _storedGameData;

  _FriendsUtility get friendsUtility => _friendsUtility;

  GameDatabaseManager get gameDatabaseManager => _gameDatabaseManager;

  GoogleMapsPlaces get googleMapsPlaces => _googleMapsPlaces;

  GoogleMapsDirections get googleMapsDirections => _googleMapsDirections;
}

class _StoredGameData {
  
  Position startPosition;
  List<Recipe> _recipesToBeCompleted;
  List<Recipe> _recipesToBeSold;
  List<RegisteredFriend> _friends;

  _StoredGameData(Position position, List<Recipe> recipes, List<RegisteredFriend> friends) {
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

  List<RegisteredFriend> get friends => _friends;

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
  }

  Future<List<Placemark>> placeMarkFromAddress(String address) async {
    return await _geolocator.placemarkFromAddress(address);
  }

  Future<List<Placemark>> placeMarkFromCoordinates(double latitude, double longitude) async {
    return await _geolocator.placemarkFromCoordinates(latitude, longitude);
  }

  Future<double> distanceBetweenPoints(double latitude1, double longitude1, double latitude2, double longitude2) async {
    return (await _geolocator.distanceBetween(latitude1, longitude1, latitude2, longitude2)) * 0.00062137;
  }

}

class _RecipeUtility {

  Future<List<Recipe>> generateRecipes(Position position, int count) async {
    List<PlacesSearchResult> locations = await _getNearbyLocations(position);
    List<Recipe> recipes = [];
    List<int> recipeIndexes = [];
    while (recipeIndexes.length < count) {
      int num = _randomInt(recipesList.length);
      recipeIndexes.add(num);
    }
    for (int i = 0; i < count; i++) {
      RecipeData data = recipesList[recipeIndexes[i]];
      List<int> locationIndexes = _randomNumSet(data.ingredients.length, locations.length);
      List<IngredientItem> ingredientItems = [];
      for (int c = 0; c < locationIndexes.length; c++) {
        ingredientItems.add(IngredientItem(
          data.ingredients[c],
          locations[locationIndexes[c]].geometry.location.lat,
          locations[locationIndexes[c]].geometry.location.lng,
          false,
        ));
      }
      recipes.add(new Recipe(
        data.food,
        _randomInt(30, min: 20), 
        data.sellLocation,
        ingredientItems,
      ));
    }
    return recipes;
  }

  Future<List<PlacesSearchResult>> _getNearbyLocations(Position position) async {
    int radius = 50000;
    PlacesSearchResponse response = await GameManager.instance.googleMapsPlaces.searchNearbyWithRadius(Location(position.latitude, position.longitude), radius, type: "supermarket");
    List<PlacesSearchResult> results = response.results;
    return results;
  }

  int _randomInt(int range, {int min = 0}) {
    Random random = Random();
    return min + random.nextInt(range);
  }

  List<int> _randomNumSet(int length, int max) {
    Random random = Random();
    Set<int> nums = Set();
    while (nums.length < length) {
      nums.add(random.nextInt(max));
    }
    return nums.toList();
  }

}

class _FriendsUtility {

  List<RegisteredFriend> _registeredFriends;
  List<UnregisteredFriend> _unregisteredFriends;

  _FriendsUtility() {
    _registeredFriends = [];
    _unregisteredFriends = [];
  }

  static Future<_FriendsUtility> init() async {
    _FriendsUtility friendsUtility = _FriendsUtility();
//    List<Contact> contacts = await friendsUtility._getContacts();
//    await friendsUtility._categorizeFriends(contacts);
    for (int i = 0; i < 5; i++) {
      friendsUtility._registeredFriends.add(RegisteredFriend("Sriram", "Mupparapu", 20, 50, 50, "000-000-0000", true));
    }
    return friendsUtility;
  }

  Future<List<Contact>> _getContacts() async {
    return (await ContactsService.getContacts(withThumbnails: false)).toList();
  }

  Future<void> _categorizeFriends(List<Contact> contacts) async {
    for (Contact contact in contacts) {
      List<Item> phoneNumberItems = contact.phones.toList();

      bool isRegistered = false;
      // check if contact exists in firestore and check which number exists
      if (!isRegistered) {
        _registeredFriends.add(RegisteredFriend(contact.givenName, contact.familyName, 20, 20, 20, phoneNumberItems[0].value, true));
      } else {
        _unregisteredFriends.add(UnregisteredFriend(contact.givenName, contact.familyName, "hi"));
      }
    }
  }

  List<UnregisteredFriend> get unregisteredFriends => _unregisteredFriends;

  List<RegisteredFriend> get registeredFriends => _registeredFriends;


}