// ignore_for_file: prefer_const_constructors

import 'package:cook_app/data/database.dart';
import 'package:cook_app/data/database.dart';
import 'package:cook_app/utils/add_ingredients.dart';
import 'package:flutter/material.dart';
import 'package:cook_app/utils/recipe_struct.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  // ignore: unused_field

  final TextEditingController recipeNameEditedController =
      TextEditingController();
  final TextEditingController totalTimeController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();

  final _myBox = Hive.box('mybox'); // pr charger la bdd sur home_page
  RecipeDatabase db = RecipeDatabase();

  List<String> availableFields = ['Beurre', 'Farine', 'Oeuf(s)'];
  List<String> selectedFields = [];
  String? searchQuery;
  List allIngredientSelectedEditRecipe = [];

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
              // recipe name (string)
              TextFormField(
                controller: recipeNameEditedController,
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

              // ingredients list
              TextField(),

              // Create a button who will generate a new page from recipe_struct

              // test select ingredient from al list
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
                      allIngredientSelectedEditRecipe
                          .addAll(allIngredientSelected);
                    }
                  },
                  child: Text("Add ingredients")),

              Expanded(
                child: ListView.builder(
                  itemCount: allIngredientSelectedEditRecipe.length,
                  itemBuilder: (context, index) {
                    final ingredient =
                        allIngredientSelectedEditRecipe[index][0];
                    final quantity = allIngredientSelectedEditRecipe[index][1];
                    final unit = allIngredientSelectedEditRecipe[index][2];

                    final formattedString = '$ingredient : ($quantity$unit)';
                    return ListTile(
                      title: Text(formattedString),
                    );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  // Récupérer les données du formulaire
                  String recipeNameEdited = recipeNameEditedController.text;
                  String totalTime = totalTimeController
                      .text; // Ajoutez les contrôleurs nécessaires
                  String difficulty = difficultyController.text;
                  String cost = costController.text;

                  Navigator.pop(context, recipeNameEdited);
                  // Remplacez cela par les données réelles du formulaire
                  // save in database :

                  // Créer une instance de RecipeDetailsPage avec les données du formulaire
                  //  RecipeStruct recipeDetailsPage = RecipeStruct(
                  //   recipeNameEdited: recipeNameEdited,
                  //   totalTime: totalTime,
                  //   difficulty: difficulty,
                  //   cost: cost,
                  //  allIngredientSelected: allIngredientSelectedEditRecipe,
                  // );

                  // Naviguer et vers la nouvelle page avec les données du formulaire et sauvegarder
                  //  Navigator.push(
                  //    context,
                  //  MaterialPageRoute(builder: (context) => recipeDetailsPage),
                  //);
                },
                child: Text("Edit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
