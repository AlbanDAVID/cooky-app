// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddIngred extends StatefulWidget {
  const AddIngred({super.key});

  @override
  State<AddIngred> createState() => _AddIngredState();
}

final List ingredientList = [
  "Beurre",
  "Farine",
  "Oeuf(s)",
  "Lait",
  "Sucre",
  "Poulet",
  "Boeuf",
  "Carotte",
  "Tomates",
  "Sel",
  "Poivre",
  "Huile d'olive",
  "Ail"
];

class _AddIngredState extends State<AddIngred> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add ingredients'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25, top: 95),
        child: ListView.builder(
          itemCount: ingredientList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  // UI
                  onLongPress: () {
                    Navigator.pushNamed(
                        context, '/dialbox_add_ingredient_and_quantity');
                  },
                  title: Text(ingredientList[index]),
                  contentPadding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(width: 1),
                  ),
                ),
                SizedBox(height: 8), // Adjust the height as needed
              ],
            );
          },
        ),
      ),
    );
  }
}
