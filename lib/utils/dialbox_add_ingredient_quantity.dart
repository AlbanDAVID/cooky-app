// ignore_for_file: unnecessary_string_interpolations

import 'package:cook_app/utils/add_ingredients.dart';
import 'package:flutter/material.dart';

class AddIngredientQuantity extends StatefulWidget {
  const AddIngredientQuantity({Key? key}) : super(key: key);

  @override
  State<AddIngredientQuantity> createState() => _AddIngredientQuantityState();
}

class _AddIngredientQuantityState extends State<AddIngredientQuantity> {
  List<int> numbers = List.generate(20, (index) => index + 1);
  List<String> units = ["g", "kg", "ml"];
  List finalQuantity = ["", ""];

  void addQuantity(String value) {
    setState(() {
      finalQuantity.replaceRange(0, 1, [value]);
    });
  }

  void addUnit(String value) {
    setState(() {
      finalQuantity.replaceRange(1, 2, [value]);
    });
  }

  Widget displayQuantity(List value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value[0],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Text(
          value[1],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add ingredients"),
        ),
        body: Column(children: [
          Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 50, top: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(50),
                        itemCount: numbers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('${numbers[index]}'),
                            onTap: () {
                              addQuantity('${numbers[index]}');
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(50),
                        itemCount: units.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(units[index]),
                            onTap: () {
                              addUnit('${units[index]}');
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
          Column(children: [
            Container(
              height: 200,
              child: displayQuantity(finalQuantity),
            ),
            Container(
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context, finalQuantity);
                  },
                  child: const Text('Add'),
                ))
          ]),
        ]));
  }
}
