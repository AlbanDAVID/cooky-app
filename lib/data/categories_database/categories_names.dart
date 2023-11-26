import 'package:hive_flutter/hive_flutter.dart';

// for generate categories_names.g.dart, run in CLI : flutter packages pub run build_runner build
part 'categories_names.g.dart';

@HiveType(typeId: 1)
class CategoriesNames {
  @HiveField(0)
  final String categoryName;

  CategoriesNames(this.categoryName);
}
