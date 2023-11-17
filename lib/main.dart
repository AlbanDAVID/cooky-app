// ignore_for_file: prefer_const_constructors

import 'package:cook_app/utils/add_ingredients.dart';
import 'package:cook_app/utils/create_recipe.dart';
import 'package:cook_app/utils/dialbox_add_ingredient_quantity.dart';
import 'package:cook_app/utils/show_steps.dart';
import 'package:flutter/material.dart';
import 'package:cook_app/pages/home.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init the hive
  await Hive.initFlutter();

  // open a box
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        //'/recipe': (context) => RecipeStruct(),
        '/steps': (context) => ShowSteps(),
        '/create_recipe': (context) => CreateRecipe(),
        '/add_ingredients': (context) => AddIngred(
              dataDialBox: [],
            ),
        '/dialbox_add_ingredient_and_quantity': (context) =>
            const AddIngredientQuantity(),
      },
      theme: ThemeData(primarySwatch: Colors.lightGreen),
    );
  }
}
