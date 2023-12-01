import 'package:hive_flutter/hive_flutter.dart';

class RecipeDatabase {
  // recipeList contain : [0] Recipe name, [1]Total Time, [2] Difficulty, [3] Cost, [4] Path of the photo, [5] List of ingredients, [6] List of steps, [7] Categorie of the recipe, [8] bool isFromScrap
  List recipeList = [];
  // reference our box
  final _myBox =
      Hive.box('mybox'); // pr charger la base de données sur database.dart

  // CRUD :
  // READ
  Future<void> loadData() async {
    recipeList = _myBox.get("ALL_LISTS");
  }

  // UPDATE
  void updateDataBase() {
    _myBox.put("ALL_LISTS", recipeList);
  }
}
