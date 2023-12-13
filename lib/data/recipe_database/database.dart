import 'package:hive_flutter/hive_flutter.dart';

// for recipe data :
class RecipeDatabase {
  // recipeList contain :
  //[0] Recipe name (List<String>),
  //[1] Total Time (List<String>),
  //[2] Difficulty (List<String>),
  //[3] Cost (List<String>),
  //[4] List of ingredients (List<List<dynamic>>),
  //[5] Path image (List<String?>),
  //[6] List of steps (List<List<dynamic>>),
  //[7] Category of the recipe (List<String>),
  //[8] isFromScrap (List<bool>),
  //[9] creationDate (List<String>) (it's an unique ID : 'variable_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}')
  //[10] tags (List<List<dynamic>>)
  // [11] notation stars (List<double?>) (not style used, for a future add)
  // [12] preparation time, rest time, cook time (List<List?>) (not style used, for a future add)
  // [13] ustensiles (List<String?>) (not style used, for a future add)
  //[14] url image scrap (List<String?>),
  // [15] url image scrap (List<String?>)

  List recipeList = [];

  // reference our box
  final _myBox =
      Hive.box('mybox'); // pr charger la base de données sur database.dart

  // CRUD for recipeList:
  // READ
  Future<void> loadData() async {
    recipeList = _myBox.get("ALL_LISTS");
  }

  // UPDATE
  void updateDataBase() {
    _myBox.put("ALL_LISTS", recipeList);
  }
}
