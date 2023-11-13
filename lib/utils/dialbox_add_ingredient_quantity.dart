import 'package:flutter/material.dart';

class AddIngredientQuantity extends StatefulWidget {
  const AddIngredientQuantity({Key? key}) : super(key: key);

  @override
  State<AddIngredientQuantity> createState() => _AddIngredientQuantityState();
}

class _AddIngredientQuantityState extends State<AddIngredientQuantity> {
  List<int> numbers = List.generate(20, (index) => index + 1);
  List<String> units = ["g", "kg"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add ingredients"),
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: numbers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${numbers[index]}'),
                  onTap: () {
                    // Handle item tap if needed
                  },
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: units.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(units[index]),
                  onTap: () {
                    // Handle item tap if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
