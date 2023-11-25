// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cook_app/data/database.dart';
import 'package:cook_app/data/database.dart';
import 'package:cook_app/utils/add_ingredients.dart';
import 'package:cook_app/utils/add_pics.dart';
import 'package:cook_app/utils/create_steps.dart';

import 'package:flutter/material.dart';
import 'package:cook_app/utils/recipe_struct.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  // ignore: unused_field

  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController totalTimeController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController recipeCategoryController =
      TextEditingController();

  final _myBox = Hive.box('mybox'); // pr charger la bdd sur home_page
  RecipeDatabase db = RecipeDatabase();

  List<String> availableFields = ['Beurre', 'Farine', 'Oeuf(s)'];
  List<String> selectedFields = [];
  String? searchQuery;
  List allIngredientSelectedCreateRecipe = [];
  String? pathImageSelectedFromImagePicker;
  List<String> stepsRecipeFromCreateSteps = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // recipe category
              TextFormField(
                controller: recipeCategoryController,
                decoration: const InputDecoration(labelText: 'Recipe category'),
              ),
              const SizedBox(height: 16),

              // recipe name (string)
              TextFormField(
                controller: recipeNameController,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
              ),
              const SizedBox(height: 16),

              // total tile (int)
              TextFormField(
                controller: totalTimeController,
                decoration: const InputDecoration(labelText: 'Total time'),
              ),

              // difficulty (string)
              TextFormField(
                controller: difficultyController,
                decoration: const InputDecoration(labelText: 'Difficulty'),
              ),

              // cost (string)
              const SizedBox(height: 16),
              TextFormField(
                controller: costController,
                decoration: const InputDecoration(labelText: 'Cost'),
              ),
              const SizedBox(height: 16),

              // add pics
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyImagePickerPage(),
                    ),
                  );

                  // Handle the result (finalQuantity) here
                  if (result != null) {
                    String imageSelected = result;
                    print('Received data from SecondScreen: $imageSelected');
                    setState(() {});
                    pathImageSelectedFromImagePicker = imageSelected;
                  }
                },
                child: Text("Add pic"),
              ),

              // select ingredient from a list
              ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddIngred(),
                      ),
                    );

                    // Handle the result (finalQuantity) here
                    if (result != null) {
                      List allIngredientSelected = result;
                      print(
                          'Received data from SecondScreen: $allIngredientSelected');
                      setState(() {});
                      allIngredientSelectedCreateRecipe
                          .addAll(allIngredientSelected);
                    }
                  },
                  child: Text("Add ingredients")),
              // show ingreient selected
              Expanded(
                child: ListView.builder(
                  itemCount: allIngredientSelectedCreateRecipe.length,
                  itemBuilder: (context, index) {
                    final ingredient =
                        allIngredientSelectedCreateRecipe[index][0];
                    final quantity =
                        allIngredientSelectedCreateRecipe[index][1];
                    final unit = allIngredientSelectedCreateRecipe[index][2];

                    final formattedString = '$ingredient : ($quantity$unit)';
                    return ListTile(
                      title: Text(formattedString),
                    );
                  },
                ),
              ),

              // add steps
              ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateSteps(),
                      ),
                    );

                    if (result != null) {
                      List<String> stepsRecipe = result;
                      print('Received data from SecondScreen: $stepsRecipe');
                      setState(() {});
                      stepsRecipeFromCreateSteps.addAll(stepsRecipe);
                    }
                  },
                  child: Text("Add steps")),

              // show steps added
              Expanded(
                child: ListView.builder(
                  itemCount: stepsRecipeFromCreateSteps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(
                            ' Step ${index + 1}:\n${stepsRecipeFromCreateSteps[index]}'));
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  List listOfLists = _myBox.get('ALL_LISTS') ?? [];

                  // Add a new list to the list of lists
                  listOfLists.add([
                    recipeNameController.text,
                    totalTimeController.text,
                    difficultyController.text,
                    costController.text,
                    allIngredientSelectedCreateRecipe,
                    pathImageSelectedFromImagePicker,
                    stepsRecipeFromCreateSteps,
                    recipeCategoryController.text,
                  ]);

                  // Update list of lists in Hive
                  _myBox.put('ALL_LISTS', listOfLists);

                  // Retrieve form data
                  String recipeName = recipeNameController.text;
                  String totalTime = totalTimeController.text;
                  String difficulty = difficultyController.text;
                  String cost = costController.text;

                  // Create an instance of RecipeDetailsPage with the form data
                  RecipeStruct recipeDetailsPage = RecipeStruct(
                    recipeName: recipeName,
                    totalTime: totalTime,
                    difficulty: difficulty,
                    cost: cost,
                    allIngredientSelected: allIngredientSelectedCreateRecipe,
                    pathImageSelectedFromImagePicker:
                        pathImageSelectedFromImagePicker,
                    stepsRecipeFromCreateSteps: stepsRecipeFromCreateSteps,
                  );

                  // Navigate to the new page with the form data and save
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => recipeDetailsPage),
                  );
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
