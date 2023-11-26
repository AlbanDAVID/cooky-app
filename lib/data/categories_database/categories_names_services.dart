import 'package:cook_app/data/categories_database/categories_names.dart';
import 'package:hive/hive.dart';

class CategoriesNamesService {
  // give a name to the box :
  final String _boxName = "catBox";

  // open the hive box :
  // CategoriesNames is the class we created in categories_names.dart
  Future<Box<CategoriesNames>> get _box async =>
      await Hive.openBox<CategoriesNames>(_boxName);

  // CRUD functions :

  // Create :
  Future<void> addCategory(CategoriesNames categoriesNames) async {
    var box = await _box;

    await box.add(categoriesNames);
  }

  // Read :
  Future<List<CategoriesNames>> getAllCategories() async {
    var box = await _box;
    return box.values.toList();
  }

  // Update :
  //Future<void> updateCategory(CategoriesNames categoriesNames) async {
  //var box = await _box;

//  }

  // Delete :
  Future<void> deleteCategory(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }
}
