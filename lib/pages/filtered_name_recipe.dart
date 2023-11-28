// ignore_for_file: prefer_const_constructors

import 'package:cook_app/data/recipe_database/database.dart';
import 'package:cook_app/utils/edit_recipe.dart';
import 'package:cook_app/utils/recipe_struct.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FilteredNameRecipe extends StatefulWidget {
  final String categoryName;
  const FilteredNameRecipe({super.key, required this.categoryName});

  @override
  State<FilteredNameRecipe> createState() => _FilteredNameRecipeState();
}

class _FilteredNameRecipeState extends State<FilteredNameRecipe> {
  final _myBox = Hive.box('mybox');

  RecipeDatabase db = RecipeDatabase();

  late final String finalEditRecipeName;

  // allow to loadAllData from database (recipe_database)
  loadAllData() {
    db.loadData();
    setState(() {}); // Calling setState to force the widget to be rebuilt
  }

  // send data to edit at EditRecipe()
  void sendDataToEditAtEditRecipe(
      BuildContext context,
      editAllIngredient,
      editStepsRecipe,
      editRecipeCategory,
      editRecipeName,
      editTotalTime,
      editDifficulty,
      editCost,
      index) {
    Navigator.push(
      context,
      // send data to edit at EditRecipe()
      MaterialPageRoute(
        builder: (context) => EditRecipe(
          editAllIngredient: editAllIngredient,
          editStepsRecipe: editStepsRecipe,
          editRecipeCategory: editRecipeCategory,
          editRecipeName: editRecipeName,
          editTotalTime: editTotalTime,
          editDifficulty: editDifficulty,
          editCost: editCost,
          index: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COOKY"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        // Need to wait loaAllData() before ListView.builder executed
        future: loadAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Shows a loading indicator if the function is running
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Show an error message if loadAllData() fails
            return Text('Erreur: ${snapshot.error}');
          } else {
            // Once loadAllData() is complete, constructs the ListView.builder

            return ListView.builder(
              itemCount: db.recipeList.length,
              itemBuilder: (context, index) {
                // Recipe is filtered by the category we clicked on before
                if (db.recipeList[index][7].contains(widget.categoryName)) {
                  return ListTile(
                      title: Text(db.recipeList[index][0]),
                      onTap: () {
                        setState(() {});
                        loadAllData();

                        RecipeStruct recipeInstance = RecipeStruct(
                          recipeName: db.recipeList[index][0],
                          totalTime: db.recipeList[index][1],
                          difficulty: db.recipeList[index][2],
                          cost: db.recipeList[index][3],
                          allIngredientSelected: db.recipeList[index][4],
                          pathImageSelectedFromImagePicker: db.recipeList[index]
                              [5],
                          stepsRecipeFromCreateSteps: db.recipeList[index][6],
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => recipeInstance,
                          ),
                        );
                      },
                      onLongPress: () {
                        sendDataToEditAtEditRecipe(
                            context,
                            db.recipeList[index][4],
                            db.recipeList[index][6],
                            db.recipeList[index][7],
                            db.recipeList[index][0],
                            db.recipeList[index][1],
                            db.recipeList[index][2],
                            db.recipeList[index][3],
                            index);
                      });
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          }
        },
      ),
    );
  }
}
