import 'package:hive_flutter/hive_flutter.dart';

class RecipeDatabase {
  // recipeList contain : Recipe name, Totall Time, Difficulty, Cost, Path of the photo, List of ingredients.
  List recipeList = [];
  // reference our box
  final _myBox =
      Hive.box('mybox'); // pr charger la base de données sur database.dart

  // load the data from database
  void loadData() {
    recipeList = _myBox.get("ALL_LISTS");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("ALL_LISTS", recipeList);
  }
}
