/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

import 'package:hive_flutter/hive_flutter.dart';

// for generate categories_names.g.dart, run in CLI : flutter packages pub run build_runner build
part 'categories_names.g.dart';

@HiveType(typeId: 1)
class CategoriesNames {
  @HiveField(0)
  final String categoryName;

  CategoriesNames(this.categoryName);
}
