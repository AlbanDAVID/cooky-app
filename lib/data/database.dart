import 'package:hive_flutter/hive_flutter.dart';

class RecipeDatabase {
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
