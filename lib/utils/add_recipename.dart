// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cook_app/data/categories_database/categories_names.dart';
import 'package:cook_app/data/categories_database/categories_names_services.dart';
import 'package:cook_app/pages/filtered_name_recipe.dart';
import 'package:cook_app/utils/create_recipe.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddRecipeName extends StatefulWidget {
  const AddRecipeName({super.key});

  @override
  State<AddRecipeName> createState() => _AddRecipeNameState();
}

class _AddRecipeNameState extends State<AddRecipeName> {
  final TextEditingController _controller = TextEditingController();
  final List<String> recipeNameList = [
    "Spaghetti Bolognese",
    "Chicken Alfredo",
    "Margherita Pizza",
    "Caesar Salad",
    "Chicken Tacos",
    "Mushroom Risotto",
    "Classic Burger",
    "Chicken Curry",
    "Lasagna",
    "Quinoa Vegetable Salad",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add recipe name"),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
          SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: recipeNameList.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      Navigator.pop(context, recipeNameList[index]);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreen, // Couleur du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Bords arrondis
                      ),
                    ),
                    child: Center(
                      child: Text(
                        recipeNameList[index],
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                  );
                },
              )),
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add recipe name'),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text('Add'),
                          onPressed: () async {
                            setState(() {
                              Navigator.pop(context);
                              recipeNameList.insert(0, _controller.text);
                            });
                          },
                        )
                      ],
                    );
                  });
            },
            child: Icon(Icons.add),
          ),
        ]));
  }
}
