import 'package:hive_flutter/hive_flutter.dart';

class RecipeDatabase {
  // recipeList contain :
  //[0] Recipe name (String),
  //[1] Total Time (String),
  //[2] Difficulty (String),
  //[3] Cost (String),
  //[4] List of ingredients (List of strings),
  //[5] Path image (String or File),
  //[6] List of steps (List of strings),
  //[7] Category of the recipe (String),
  //[8] isFromScrap (bool),
  //[9] creationDate (String)
  //[10] tags (List)
  // For a future add :
  // [11] notation stars (Double)
  // [12] preparation time, rest time, cook time (List)
  // [13] ustensiles (List)

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
