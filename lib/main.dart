// ignore_for_file: prefer_const_constructors

import 'package:cook_app/utils/add_ingredients.dart';
import 'package:cook_app/utils/categories_names.dart';
import 'package:cook_app/utils/categories_names_services.dart';
import 'package:cook_app/utils/create_recipe.dart';
import 'package:cook_app/utils/dialbox_add_ingredient_quantity.dart';
import 'package:cook_app/utils/steps_struct.dart';
import 'package:flutter/material.dart';
import 'package:cook_app/pages/home.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init the hive
  await Hive.initFlutter();

  // Call the hive adapter we created for caterogires recipe name
  Hive.registerAdapter(CategoriesNamesAdapter());

  // open a box
  var box = await Hive.openBox('mybox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CategoriesNamesService _categoriesNamesService =
      CategoriesNamesService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _categoriesNamesService.getAllCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoriesNames>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      routes: {
        //'/recipe': (context) => RecipeStruct(),

        '/create_recipe': (context) => CreateRecipe(),
        '/add_ingredients': (context) => AddIngred(),
        '/dialbox_add_ingredient_and_quantity': (context) =>
            const AddIngredientQuantity(),
      },
      theme: ThemeData(primarySwatch: Colors.lightGreen),
    );
  }
}
