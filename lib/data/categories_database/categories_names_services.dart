/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// ignore_for_file: unused_local_variable

import 'package:Cooky/data/categories_database/categories_names.dart';
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
  Future<void> updateCategory(CategoriesNames categoriesName) async {
    var box = await _box;
    categoriesName != categoriesName;
  }

  // Delete :
  Future<void> deleteCategory(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }
}
