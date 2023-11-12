// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/database.dart';

class RecipeStruct extends StatelessWidget {
  final String recipeName;
  final String totalTime;
  final String difficulty;
  final String cost;
  const RecipeStruct({
    super.key,
    required this.recipeName,
    required this.totalTime,
    required this.difficulty,
    required this.cost,
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

              // Espacement entre le titre et l'image
              SizedBox(height: 16),

              // Recipe picture
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset('recipe_pics/photo_boeuf_bourguignon.jpg'),
                ),
              ),

              // Espacement entre le titre et l'image
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

              // Espacement entre le titre et l'image
              SizedBox(height: 30),
              Text(
                "INGREDIENTS (0/?)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Ingrédients (ajouter une case à cocher)
              Container(
                height: 300,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("4 oignons"),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                  ],
                ),
              ),

              // Espacement entre le titre et l'image
              SizedBox(height: 16),

              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, '/steps');
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


// A FAIRE / AJOUTER : 
// bouton edit etc.
// espacer 