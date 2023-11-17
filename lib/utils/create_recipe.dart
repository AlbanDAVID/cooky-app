// ignore_for_file: prefer_const_constructors

import 'package:cook_app/data/database.dart';
import 'package:cook_app/data/database.dart';
import 'package:cook_app/utils/add_ingredients.dart';
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

  final _myBox = Hive.box('mybox'); // pr charger la bdd sur home_page
  RecipeDatabase db = RecipeDatabase();

  List<String> availableFields = ['Beurre', 'Farine', 'Oeuf(s)'];
  List<String> selectedFields = [];
  String? searchQuery;
  List allIngredientSelectedCreateRecipe = [];

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
                      allIngredientSelectedCreateRecipe
                          .addAll(allIngredientSelected);
                    }
                  },
                  child: Text("Add ingredients")),

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

              ElevatedButton(
                onPressed: () {
                  List listOfLists = _myBox.get('ALL_LISTS') ?? [];

                  // Ajouter une nouvelle liste à la liste de listes
                  listOfLists.add([
                    recipeNameController.text,
                    totalTimeController.text,
                    difficultyController.text,
                    costController.text,
                    allIngredientSelectedCreateRecipe
                  ]);

                  // Mettre à jour la liste de listes dans Hive
                  _myBox.put('ALL_LISTS', listOfLists);

                  // Récupérer les données du formulaire
                  String recipeName = recipeNameController.text;
                  String totalTime = totalTimeController
                      .text; // Ajoutez les contrôleurs nécessaires
                  String difficulty = difficultyController.text;
                  String cost = costController.text;
                  // Remplacez cela par les données réelles du formulaire
                  // save in database :

                  // Créer une instance de RecipeDetailsPage avec les données du formulaire
                  RecipeStruct recipeDetailsPage = RecipeStruct(
                    recipeName: recipeName,
                    totalTime: totalTime,
                    difficulty: difficulty,
                    cost: cost,
                    allIngredientSelected: allIngredientSelectedCreateRecipe,
                  );

                  // Naviguer et vers la nouvelle page avec les données du formulaire et sauvegarder
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => recipeDetailsPage),
                  );
                },
                child: Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
