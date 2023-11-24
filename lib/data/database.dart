import 'package:hive_flutter/hive_flutter.dart';

// database who contains Recipe name, Totall Time, Difficulty, Cost, Path of the photo, List of ingredients, Steps, Recipe Category
class RecipeDatabase {
  // recipeList contain : Recipe name, Totall Time, Difficulty, Cost, Path of the photo, List of ingredients, Steps, Recipe Category
  List recipeList = [];

  List categoryRecipeList = [
    "Starter",
    "Main",
    "Dessert",
    "toto",
    "titi",
  ];

  // reference our box
  final _myBox =
      Hive.box('mybox'); // pr charger la base de données sur database.dart

  final _myBox2 = Hive.box('mybox2');

  // load the data from database
  void loadData() {
    recipeList = _myBox.get("ALL_LISTS");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("ALL_LISTS", recipeList);
  }

  loadDataCategoryRecipeDatabase() {
    categoryRecipeList = _myBox2.get("ALL_LISTS");
    print("hello");
  }

  void updateDataBaseCategoryRecipeDatabase() {
    _myBox2.put("ALL_LISTS", categoryRecipeList);
  }
}

// Database who contains category recipe
//class CategoryRecipeDatabase {
//  List categoryRecipeList = [
//    "Starter",
//    "Main",
//    "Dessert",
//    "toto",
//    "titi",
//    "tt",
//    "ff"
//  ];
//
//  // reference our box
//  final _myBox2 =
//      Hive.box('mybox2'); // pr charger la base de données sur database.dart
//
//  // load the data from database
//  Future<void> loadDataCategoryRecipeDatabase() async {
//    categoryRecipeList = _myBox2.get("AL");
//  }
//
//  // update the database
//  void updateDataBaseCategoryRecipeDatabase() {
//    _myBox2.put("AL", categoryRecipeList);
//  }
//}
