/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

import 'package:hive_flutter/hive_flutter.dart';

// for language data :
class LanguageDatabase {
  String? languageSelected;
  // reference our box
  final _myBox =
      Hive.box('mybox'); // pr charger la base de données sur database.dart

  // CRUD for languageSelected
  loadDataLanguage() {
    languageSelected = _myBox.get("LANGUAGE");
  }

  // UPDATE
  updateDataBase() {
    _myBox.put("LANGUAGE", languageSelected);
  }
}
