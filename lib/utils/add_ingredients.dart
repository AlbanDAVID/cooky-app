import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddIngred extends StatefulWidget {
  const AddIngred({super.key});

  @override
  State<AddIngred> createState() => _AddIngredState();
}

final List ingredientList = ["Beurre", "Farine", "Oeuf(s)", "Lait"];

class _AddIngredState extends State<AddIngred> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add ingredients'),
      ),
      body: ListView.builder(
          itemCount: ingredientList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(ingredientList[index]),
            );
          }),
    );
  }
}
