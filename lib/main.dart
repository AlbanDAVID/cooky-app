// ignore_for_file: prefer_const_constructors, override_on_non_overriding_member

import 'package:cook_app/pages/about.dart';
import 'package:cook_app/pages/language.dart';
import 'package:cook_app/pages/add_ingredients.dart';
import 'package:cook_app/data/categories_database/categories_names.dart';
import 'package:cook_app/data/categories_database/categories_names_services.dart';
import 'package:cook_app/pages/create_recipe.dart';
import 'package:cook_app/utils/dialbox_add_ingredient_quantity.dart';
import 'package:flutter/material.dart';
import 'package:cook_app/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init the hive
  await Hive.initFlutter();

  // Call the hive adapter we created for caterogires recipe name
  Hive.registerAdapter(CategoriesNamesAdapter());

  // open a box (my box is used to load all data selected in CreateRecipe)
  // All the data are in a list "recipeList" which contain : [0] Recipe name, [1]Total Time, [2] Difficulty, [3] Cost, [4] Path of the photo, [5] List of ingredients, [6] List of steps, [7] Categorie of the recipe
  var box = await Hive.openBox('mybox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CategoriesNamesService _categoriesNamesService =
      CategoriesNamesService();

  MyApp({super.key});

  @override

  // open mybox for get the language preference
  final _myBox = Hive.box('mybox');

  // if no language selected, by default the app will take the phone language supported (en, fr). But, il the user want to choose, the new languge preference will be saved
  checkLanguagePref() {
    if (_myBox.get("LANGUAGE") != null) {
      return Locale(_myBox.get("LANGUAGE"));
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooky',
      // internationalization
      locale:
          checkLanguagePref(), // if _myBox.get("LANGUAGE") != null : the user will have the language selected. Else, checkLanguagePref() return null value and as indicated in the doc of "locale" variable If the 'locale' is null then the system's locale value is used.

      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
      ],

      debugShowCheckedModeBanner: false,
      // use FuturBuilder to load all data from "catBox" when app is started and go to the Home page(the hive box from CategoriesNamesService wih all the categories)
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
        '/language': (context) => const Language(),
        '/about': (context) => const About(),
        '/home': (context) => const Home(),
      },
    );
  }
}
