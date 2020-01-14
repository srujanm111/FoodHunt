import 'package:flutter/material.dart';

const Color primary = Color(0xFF3D4FF4);
const Color primaryFaded = Color(0xFFB4BBFF);
const Color border = Color(0xFFDCDCDC);
const Color darkGray = Color(0xFF707070);
const Color green = Color(0xFF0DC018);
const Color lightGray = Color(0xFFD8D8D8);
const Color yellow = Color(0xFFE79D1C);
const Color black = Color(0xFF000000);
const Color orange = Color(0xFFE76129);
const Color white = Color(0xFFFFFFFF);
const Color red = Color(0xFFF5492F);

enum Food {
  pasta,
  sandwich,
  hotDog,
  burrito,
  specialCoffee,
  pizza,
  deluxeIceCream,
  friedRice,
  pumpkinPie,
  pancakes,
  fruitSmoothie,
  specialSoda,
  breakfastBurrito,
  cake,
  clubSoda,
}

enum Ingredient {
  bread,
  cheese,
  lettuce,
  tomato,
  turkey,
  flour,
  eggs,
  onion,
  basil,
  sausage,
  ketchup,
  mustard,
  tortilla,
  beans,
  chicken,
  coffeeBeans,
  sugar,
  chocolate,
  whippedCream,
  pepperoni,
  milk,
  strawberries,
  bananas,
  candy,
  rice,
  carrots,
  peas,
  soySauce,
  pumpkin,
  cinnamon,
  butter,
  ice,
  orange,
  orangeJuice,
  cornSyrup,
  purifiedWater,
  carbonatedWater
}

enum SellLocation {
  restaurant,
  bar,
  cafe,
  bakery
}

const Map<Food, String> foodImageName = {
  Food.breakfastBurrito : "breakfast_burrito.png",
  Food.burrito : "burrito.png",
  Food.cake : "cake.png",
  Food.clubSoda : "club_soda.png",
  Food.deluxeIceCream : "deluxe_ice_cream.png",
  Food.friedRice : "fried_rice.png",
  Food.fruitSmoothie : "fruit_smoothie.png",
  Food.hotDog : "hot_dog.png",
  Food.pancakes : "pancakes.png",
  Food.pasta : "pasta.png",
  Food.pizza : "pizza.png",
  Food.pumpkinPie : "pumpkin_pie.png",
  Food.sandwich : "sandwich.png",
  Food.specialCoffee : "special_coffee.png",
  Food.specialSoda : "special_soda.png",
};

const Map<Food, String> foodName = {
  Food.breakfastBurrito : "Breakfast Burrito",
  Food.burrito : "Burrito",
  Food.cake : "Cake",
  Food.clubSoda : "Club Soda",
  Food.deluxeIceCream : "Deluxe Ice Cream",
  Food.friedRice : "Fried Rice",
  Food.fruitSmoothie : "Fruit Smoothie",
  Food.hotDog : "Hot Dog",
  Food.pancakes : "Pancakes",
  Food.pasta : "Pasta",
  Food.pizza : "Pizza",
  Food.pumpkinPie : "Pumpkin Pie",
  Food.sandwich : "Sandwich",
  Food.specialCoffee : "Special Coffee",
  Food.specialSoda : "Special Soda",
};

const Map<String, Food> nameFood = {
  "Breakfast Burrito" : Food.breakfastBurrito,
  "Burrito" : Food.burrito,
  "Cake" : Food.cake,
  "Club Soda" : Food.clubSoda,
  "Deluxe Ice Cream" : Food.deluxeIceCream,
  "Fried Rice" : Food.friedRice,
  "Fruit Smoothie" : Food.fruitSmoothie,
  "Hot Dog" : Food.hotDog,
  "Pancakes" : Food.pancakes,
  "Pasta" : Food.pasta,
  "Pizza" : Food.pizza,
  "Pumpkin Pie" : Food.pumpkinPie,
  "Sandwich" : Food.sandwich,
  "Special Coffee" : Food.specialCoffee,
  "Special Soda" : Food.specialSoda,
};

const Map<Ingredient, String> ingredientImageName = {
  Ingredient.bananas : "bananas.png",
  Ingredient.basil : "basil.png",
  Ingredient.beans : "beans.png",
  Ingredient.bread : "bread.png",
  Ingredient.butter : "butter.png",
  Ingredient.candy : "candy.png",
  Ingredient.carbonatedWater : "carbonated_water.png",
  Ingredient.carrots : "carrots.png",
  Ingredient.cheese : "cheese.png",
  Ingredient.chicken : "chicken.png",
  Ingredient.chocolate : "chocolate.png",
  Ingredient.cinnamon : "cinnamon.png",
  Ingredient.coffeeBeans : "coffee_beans.png",
  Ingredient.cornSyrup : "corn_syrup.png",
  Ingredient.eggs : "eggs.png",
  Ingredient.flour : "flour.png",
  Ingredient.ice : "ice.png",
  Ingredient.ketchup : "ketchup.png",
  Ingredient.lettuce : "lettuce.png",
  Ingredient.milk : "milk.png",
  Ingredient.mustard : "mustard.png",
  Ingredient.onion : "onion.png",
  Ingredient.orangeJuice : "orange_juice.png",
  Ingredient.orange : "orange.png",
  Ingredient.peas : "peas.png",
  Ingredient.pepperoni : "pepperoni.png",
  Ingredient.pumpkin : "pumpkin.png",
  Ingredient.purifiedWater : "purified_water.png",
  Ingredient.rice : "rice.png",
  Ingredient.sausage : "sausage.png",
  Ingredient.soySauce : "soy_sauce.png",
  Ingredient.strawberries : "strawberries.png",
  Ingredient.sugar : "sugar.png",
  Ingredient.tomato : "tomato.png",
  Ingredient.tortilla : "tortilla.png",
  Ingredient.turkey : "turkey.png",
  Ingredient.whippedCream : "whipped_cream.png",
};

const Map<Ingredient, String> ingredientName = {
  Ingredient.bananas : "Bananas",
  Ingredient.basil : "Basil",
  Ingredient.beans : "Beans",
  Ingredient.bread : "Bread",
  Ingredient.butter : "Butter",
  Ingredient.candy : "Candy",
  Ingredient.carbonatedWater : "Carbonated Water",
  Ingredient.carrots : "Carrots",
  Ingredient.cheese : "Cheese",
  Ingredient.chicken : "Chicken",
  Ingredient.chocolate : "Chocolate",
  Ingredient.cinnamon : "Cinnamon",
  Ingredient.coffeeBeans : "Coffee Beans",
  Ingredient.cornSyrup : "Corn Syrup",
  Ingredient.eggs : "Eggs",
  Ingredient.flour : "Flour",
  Ingredient.ice : "Ice",
  Ingredient.ketchup : "Ketchup",
  Ingredient.lettuce : "Lettuce",
  Ingredient.milk : "Milk",
  Ingredient.mustard : "Mustard",
  Ingredient.onion : "Onion",
  Ingredient.orangeJuice : "Orange Juice",
  Ingredient.orange : "Orange",
  Ingredient.peas : "Peas",
  Ingredient.pepperoni : "Pepperoni",
  Ingredient.pumpkin : "Pumpkin",
  Ingredient.purifiedWater : "Purified Water",
  Ingredient.rice : "Rice",
  Ingredient.sausage : "Sausage",
  Ingredient.soySauce : "Soy Sauce",
  Ingredient.strawberries : "Strawberries",
  Ingredient.sugar : "Sugar",
  Ingredient.tomato : "Tomato",
  Ingredient.tortilla : "Tortilla",
  Ingredient.turkey : "Turkey",
  Ingredient.whippedCream : "Whipped Cream",
};

const Map<String, Ingredient> nameIngredient = {
  "Bananas" : Ingredient.bananas,
  "Basil" : Ingredient.basil,
  "Beans" : Ingredient.beans,
  "Bread" : Ingredient.bread,
  "Butter" : Ingredient.butter,
  "Candy" : Ingredient.candy,
  "Carbonated Water" : Ingredient.carbonatedWater,
  "Carrots" : Ingredient.carrots,
  "Cheese" : Ingredient.cheese,
  "Chicken" : Ingredient.chicken,
  "Chocolate" : Ingredient.chocolate,
  "Cinnamon" : Ingredient.cinnamon,
  "Coffee Beans" : Ingredient.coffeeBeans,
  "Corn Syrup" : Ingredient.cornSyrup,
  "Eggs" : Ingredient.eggs,
  "Flour" : Ingredient.flour,
  "Ice" : Ingredient.ice,
  "Ketchup" : Ingredient.ketchup,
  "Lettuce" : Ingredient.lettuce,
  "Milk" : Ingredient.milk,
  "Mustard" : Ingredient.mustard,
  "Onion" : Ingredient.onion,
  "Orange Juice" : Ingredient.orangeJuice,
  "Orange" : Ingredient.orange,
  "Peas" : Ingredient.peas,
  "Pepperoni" : Ingredient.pepperoni,
  "Pumpkin" : Ingredient.pumpkin,
  "Purified Water" : Ingredient.purifiedWater,
  "Rice" : Ingredient.rice,
  "Sausage" : Ingredient.sausage,
  "Soy Sauce" : Ingredient.soySauce,
  "Strawberries" : Ingredient.strawberries,
  "Sugar" : Ingredient.sugar,
  "Tomato" : Ingredient.tomato,
  "Tortilla" : Ingredient.tortilla,
  "Turkey" : Ingredient.turkey,
  "Whipped Cream" : Ingredient.whippedCream,
};

const Map<SellLocation, String> sellLocationImageName = {
  SellLocation.bar : "bar.png",
  SellLocation.cafe : "cafe.png",
  SellLocation.bakery : "bakery.png",
  SellLocation.restaurant : "restaurant.png",
};

const Map<SellLocation, String> sellLocationName = {
  SellLocation.bar : "Bar",
  SellLocation.cafe : "Cafe",
  SellLocation.bakery : "Bakery",
  SellLocation.restaurant : "Restaurant",
};

const Map<String, SellLocation> nameSellLocation = {
  "Bar" : SellLocation.bar,
  "Cafe" : SellLocation.cafe,
  "Bakery" : SellLocation.bakery,
  "Restaurant" : SellLocation.restaurant,
};

const Map<SellLocation, String> sellLocationSearchParameter = {
  SellLocation.bar : "bar",
  SellLocation.cafe : "cafe",
  SellLocation.bakery : "bakery",
  SellLocation.restaurant : "restaurant",
};

class RecipeData {
  Food food;
  List<Ingredient> ingredients;
  SellLocation sellLocation;

  RecipeData({this.food, this.ingredients, this.sellLocation});
}

List<RecipeData> recipesList = [
  RecipeData(
    food: Food.pasta,
    ingredients: [
      Ingredient.tomato,
      Ingredient.flour,
      Ingredient.eggs,
      Ingredient.onion,
      Ingredient.basil,
    ],
    sellLocation: SellLocation.restaurant,
  ),
  RecipeData(
    food: Food.sandwich,
    ingredients: [
      Ingredient.bread,
      Ingredient.tomato,
      Ingredient.lettuce,
      Ingredient.cheese,
      Ingredient.turkey,
    ],
    sellLocation: SellLocation.cafe,
  ),
  RecipeData(
    food: Food.hotDog,
    ingredients: [
      Ingredient.sausage,
      Ingredient.bread,
      Ingredient.ketchup,
      Ingredient.mustard,
    ],
    sellLocation: SellLocation.restaurant,
  ),
  RecipeData(
    food: Food.burrito,
    ingredients: [
      Ingredient.tortilla,
      Ingredient.cheese,
      Ingredient.beans,
      Ingredient.lettuce,
      Ingredient.chicken,
    ],
    sellLocation: SellLocation.restaurant,
  ),
  RecipeData(
    food: Food.specialCoffee,
    ingredients: [
      Ingredient.coffeeBeans,
      Ingredient.sugar,
      Ingredient.chocolate,
      Ingredient.whippedCream,
    ],
    sellLocation: SellLocation.cafe,
  ),
  RecipeData(
    food: Food.pizza,
    ingredients: [
      Ingredient.flour,
      Ingredient.cheese,
      Ingredient.pepperoni,
      Ingredient.tomato,
    ],
    sellLocation: SellLocation.bakery,
  ),
  RecipeData(
    food: Food.deluxeIceCream,
    ingredients: [
      Ingredient.milk,
      Ingredient.strawberries,
      Ingredient.bananas,
      Ingredient.sugar,
      Ingredient.chocolate,
      Ingredient.candy,
    ],
    sellLocation: SellLocation.cafe,
  ),
  RecipeData(
    food: Food.friedRice,
    ingredients: [
      Ingredient.rice,
      Ingredient.carrots,
      Ingredient.peas,
      Ingredient.eggs,
      Ingredient.soySauce,
    ],
    sellLocation: SellLocation.restaurant,
  ),
  RecipeData(
    food: Food.pumpkinPie,
    ingredients: [
      Ingredient.pumpkin,
      Ingredient.flour,
      Ingredient.whippedCream,
      Ingredient.sugar,
      Ingredient.cinnamon,
      Ingredient.eggs,
    ],
    sellLocation: SellLocation.bakery,
  ),
  RecipeData(
    food: Food.pancakes,
    ingredients: [
      Ingredient.flour,
      Ingredient.butter,
      Ingredient.eggs,
      Ingredient.milk,
      Ingredient.sugar,
    ],
    sellLocation: SellLocation.bakery,
  ),
  RecipeData(
    food: Food.fruitSmoothie,
    ingredients: [
      Ingredient.milk,
      Ingredient.ice,
      Ingredient.orange,
      Ingredient.strawberries,
      Ingredient.bananas,
    ],
    sellLocation: SellLocation.bar,
  ),
  RecipeData(
    food: Food.specialSoda,
    ingredients: [
      Ingredient.sugar,
      Ingredient.orangeJuice,
      Ingredient.cornSyrup,
      Ingredient.purifiedWater,
    ],
    sellLocation: SellLocation.bar,
  ),
  RecipeData(
    food: Food.breakfastBurrito,
    ingredients: [
      Ingredient.tortilla,
      Ingredient.tomato,
      Ingredient.eggs,
      Ingredient.cheese,
    ],
    sellLocation: SellLocation.restaurant,
  ),
  RecipeData(
    food: Food.cake,
    ingredients: [
      Ingredient.butter,
      Ingredient.eggs,
      Ingredient.flour,
      Ingredient.whippedCream,
      Ingredient.chocolate,
      Ingredient.milk,
    ],
    sellLocation: SellLocation.bakery,
  ),
  RecipeData(
    food: Food.clubSoda,
    ingredients: [
      Ingredient.purifiedWater,
      Ingredient.carbonatedWater,
    ],
    sellLocation: SellLocation.bar,
  ),
];