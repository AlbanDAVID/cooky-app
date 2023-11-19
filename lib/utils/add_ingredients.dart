// ignore_for_file: prefer_const_constructors

import 'package:cook_app/utils/dialbox_add_ingredient_quantity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddIngred extends StatefulWidget {
  const AddIngred({super.key});

  @override
  State<AddIngred> createState() => _AddIngredState();
}

class _AddIngredState extends State<AddIngred> {
  final List ingredientList = [
    "Butter",
    "Flour",
    "Egg(s)",
    "Milk",
    "Sugar",
    "Chicken",
    "Beef",
    "Carrot",
    "Tomatoes",
    "Salt",
    "Pepper",
    "Olive Oil",
    "Garlic"
  ];

  final List selectedIngredientName = [];

  final List allIngredientSelected = [];

  @override
  Widget build(BuildContext context) {
    // add list from dialbox_add_ingredient to allIngredientSelected
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add ingredients'),
        ),
        body: Column(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50, top: 0),
            child: ListView.builder(
              itemCount: ingredientList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // UI
                  onLongPress: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddIngredientQuantity(),
                      ),
                    );

                    // Handle the result (finalQuantity) here
                    if (result != null) {
                      List finalQuantity = result;
                      print('Received data from SecondScreen: $finalQuantity');
                      setState(() {});
                      finalQuantity.insert(0, ingredientList[index]);
                      allIngredientSelected.add(finalQuantity);
                    }
                  },
                  title: Text(ingredientList[index]),
                  // to add an outline to the text (beware of bug: the scroll takes up the entire page) :
                  //contentPadding: EdgeInsets.all(20),
                  //shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.circular(10),
                  //side: BorderSide(width: 1),
                  //),
                );
                // Adjust the height as needed
              },
            ),
          )),
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
          Container(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context, allIngredientSelected);
                },
                child: const Text('Add'),
              ))
        ]));
  }
}
