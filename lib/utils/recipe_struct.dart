// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cook_app/utils/add_pics.dart';
import 'package:cook_app/utils/steps_struct.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/database.dart';

class RecipeStruct extends StatelessWidget {
  final String recipeName;
  final String totalTime;
  final String difficulty;
  final String cost;
  final List allIngredientSelected;
  final String? pathImageSelectedFromImagePicker;
  final List<String> stepsRecipeFromCreateSteps;

  const RecipeStruct({
    super.key,
    required this.recipeName,
    required this.totalTime,
    required this.difficulty,
    required this.cost,
    required this.allIngredientSelected,
    required this.pathImageSelectedFromImagePicker,
    required this.stepsRecipeFromCreateSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 40, top: 50),
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Column(
            children: [
              // Title (recipe name)
              Text(
                recipeName,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Spacing between title and image
              SizedBox(height: 16),

              // Recipe picture
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: pathImageSelectedFromImagePicker != null
                      ? Image.file(
                          File(pathImageSelectedFromImagePicker!),
                        ) // File(imageSelectedFromImagePicker!) to transform string path to a widget (ClipRRect does not support Imge.file with just string path, need a widget)
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyImagePickerPage()),
                            );
                          },
                          child: Text("Add pic")),
                ),
              ),

              // Spacing between title and image
              SizedBox(height: 16),

              // Row for info (time, difficulty, cost)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Total time
                  Text(
                    totalTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Difficulty
                  Text(
                    difficulty,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Cost
                  Text(
                    cost,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Spacing between title and image
              SizedBox(height: 30),
              Text(
                "INGREDIENTS (0/?)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Ingrédients (TODO : add checkbox)
              Expanded(
                child: ListView.builder(
                  itemCount: allIngredientSelected.length,
                  itemBuilder: (context, index) {
                    final ingredient = allIngredientSelected[index][0];
                    final quantity = allIngredientSelected[index][1];
                    final unit = allIngredientSelected[index][2];

                    final formattedString = '$ingredient : ($quantity$unit)';
                    return ListTile(
                      title: Text(formattedString),
                    );
                  },
                ),
              ),

              // Spacing between title and image
              SizedBox(height: 16),

              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowRecipeSteps(
                              steps: stepsRecipeFromCreateSteps,
                            )),
                  );
                },
                label: Text("Start to cook!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
