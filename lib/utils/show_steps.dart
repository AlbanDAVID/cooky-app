// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/database.dart';

class ShowSteps extends StatelessWidget {
  const ShowSteps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25, top: 40),
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Column(
            children: [
              // Ingrédients (ajouter une case à cocher)
              Expanded(
                child: ListView(
                  children: [
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("STEP 1"),
                      subtitle: Text(
                          "Détailler la viande en cubes de 3 cm de côté, enlever les gros morceaux de gras."),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                    // Ajouter d'autres ingrédients de manière similaire
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("STEP 2"),
                      subtitle: Text(
                          "Couper l'oignon en morceaux. Le faire revenir dans une poêle au beurre. Une fois transparent, le verser dans une cocotte en fonte de préférence. "),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("STEP 2"),
                      subtitle: Text(
                          "Couper l'oignon en morceaux. Le faire revenir dans une poêle au beurre. Une fois transparent, le verser dans une cocotte en fonte de préférence. "),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("STEP 2"),
                      subtitle: Text(
                          "Couper l'oignon en morceaux. Le faire revenir dans une poêle au beurre. Une fois transparent, le verser dans une cocotte en fonte de préférence. "),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("STEP 2"),
                      subtitle: Text(
                          "Couper l'oignon en morceaux. Le faire revenir dans une poêle au beurre. Une fois transparent, le verser dans une cocotte en fonte de préférence. "),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("STEP 2"),
                      subtitle: Text(
                          "Couper l'oignon en morceaux. Le faire revenir dans une poêle au beurre. Une fois transparent, le verser dans une cocotte en fonte de préférence. "),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("STEP 2"),
                      subtitle: Text(
                          "Couper l'oignon en morceaux. Le faire revenir dans une poêle au beurre. Une fois transparent, le verser dans une cocotte en fonte de préférence. "),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("STEP 2"),
                      subtitle: Text(
                          "Couper l'oignon en morceaux. Le faire revenir dans une poêle au beurre. Une fois transparent, le verser dans une cocotte en fonte de préférence. "),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                    // Exemple d'ingrédient avec une case à cocher
                    CheckboxListTile(
                      title: Text("STEP 2"),
                      subtitle: Text(
                          "Couper l'oignon en morceaux. Le faire revenir dans une poêle au beurre. Une fois transparent, le verser dans une cocotte en fonte de préférence. "),
                      value:
                          false, // Définir la valeur en fonction de l'état de la case à cocher
                      onChanged: (bool? value) {
                        // Logique à exécuter lorsque la case à cocher est modifiée
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
