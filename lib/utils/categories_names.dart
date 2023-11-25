import 'package:hive_flutter/hive_flutter.dart';
part 'categories_names.g.dart';

@HiveType(typeId: 1)
class CategoriesNames {
  @HiveField(0)
  final String categoryName;

  CategoriesNames(this.categoryName);
}
