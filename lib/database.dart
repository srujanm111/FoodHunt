import 'package:food_hunt/constants.dart';
import 'package:food_hunt/data_classes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String idLabel = "id";

const String recipesTableLabel = "Recipes";
const String friendsTableLabel = "Friends";
const String ingredientItemsTableLabel = "IngredientItems";

const String foodLabel = "food";
const String sellPriceLabel = "sellPrice";
const String sellLocationLabel = "sellLocation";
const String ingredientItemLabel = "ingredientItem";
const String ingredientLabel = "ingredient";
const String latitudeLabel = "latitude";
const String longitudeLabel = "longitude";
const String isFoundLabel = "found";
const String firstNameLabel = "firstName";
const String lastNameLabel = "lastName";
const String phoneNumberLabel = "phoneNumber";
const String isInContactsLabel = "inContacts";
const String isCompleteLabel = "complete";

class GameDatabaseManager {

  Database _database;

  static Future<GameDatabaseManager> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'food_hunt.db');

    GameDatabaseManager _gameDatabaseManager = new GameDatabaseManager();
    _gameDatabaseManager._database = await openDatabase(path, version: 1,
      onCreate: (Database _database, int version) async {
        await _database.execute('''
          CREATE TABLE $recipesTableLabel (
            $idLabel INTEGER PRIMARY KEY,
            $foodLabel TEXT NOT NULL,
            $sellPriceLabel INTEGER NOT NULL,
            $sellLocationLabel TEXT NOT NULL,
            $isCompleteLabel INTEGER NOT NULL
          )
        ''');
        await _database.execute('''
          CREATE TABLE $ingredientItemsTableLabel (
            $idLabel INTEGER PRIMARY KEY,
            $ingredientLabel TEXT NOT NULL,
            $latitudeLabel REAL NOT NULL,
            $longitudeLabel REAL NOT NULL,
            $isFoundLabel INTEGER NOT NULL,
            recipe INTEGER NOT NULL,
            FOREIGN KEY (recipe) REFERENCES $recipesTableLabel ($idLabel)
              ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');
        await _database.execute('''
          CREATE TABLE $friendsTableLabel (
            $idLabel INTEGER PRIMARY KEY,
            $firstNameLabel TEXT NOT NULL,
            $lastNameLabel TEXT NOT NULL,
            $phoneNumberLabel TEXT NOT NULL,
            $latitudeLabel REAL NOT NULL,
            $longitudeLabel REAL NOT NULL,
            $isInContactsLabel INTEGER NOT NULL
          )
        ''');
      });

    return _gameDatabaseManager;
  }

  Future<List<Recipe>> getRecipes() async {
    List<Map> recipeMaps = await _database.query(recipesTableLabel);
    List<Recipe> recipes = [];
    for (Map map in recipeMaps) {
      Recipe recipe = Recipe.fromMap(map);
      recipe.ingredients = await getIngredientItems(recipe.id);
      recipes.add(recipe);
    }
    return recipes;
  }

  Future<List<IngredientItem>> getIngredientItems(int key) async {
    List<Map> ingredientItemMaps = await _database.query(ingredientItemsTableLabel, where: "recipe = ?", whereArgs: [key]);
    List<IngredientItem> ingredients = [];
    for (Map map in ingredientItemMaps) {
      ingredients.add(IngredientItem.fromMap(map));
    }
    return ingredients;
  }

  Future<List<RegisteredFriend>> getFriends() async {
    List<Map> friendMaps = await _database.query(friendsTableLabel,);
    List<RegisteredFriend> friends = [];
    for (Map map in friendMaps) {
      friends.add(RegisteredFriend.fromMap(map));
    }
    return friends;
  }

  Future<void> upsertRecipe(Recipe recipe, bool complete) async {
    Map<String, dynamic> map = recipe.toMap();
    map[isCompleteLabel] = complete ? 1 : 0;
    if (recipe.id == null) {
      recipe.id = await _database.insert(recipesTableLabel, map);
    } else {
      await _database.update(recipesTableLabel, map, where: "$idLabel = ?", whereArgs: [recipe.id]);
    }
  }

  Future<void> upsertIngredientItem(IngredientItem item, int key) async {
    if (item.id == null) {
      Map<String, dynamic> map = item.toMap();
      map['recipe'] = key;
      item.id = await _database.insert(ingredientItemsTableLabel, map);
    } else {
      await _database.update(ingredientItemsTableLabel, item.toMap(), where: "$idLabel = ?", whereArgs: [item.id]);
    }
  }

  Future<void> upsertFriend(RegisteredFriend friend) async {
    if (friend.id == null) {
      friend.id = await _database.insert(friendsTableLabel, friend.toMap());
    } else {
      await _database.update(friendsTableLabel, friend.toMap(), where: "$idLabel = ?", whereArgs: [friend.id]);
    }
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    await _database.delete(recipesTableLabel, where: "$idLabel = ?", whereArgs: [recipe.id]);
  }

}