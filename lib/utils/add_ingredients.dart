import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddIngred extends StatefulWidget {
  const AddIngred({
    Key? key,
    required this.dataDialBox,
  }) : super(key: key);

  final List dataDialBox;

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

final List allIngredientSelected = [""];

Widget displayAllIngredientSelected() {
  return ListView.builder(
    itemCount: allIngredientSelected.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text('${allIngredientSelected[index]}'),
      );
    },
  );
}

class _AddIngredState extends State<AddIngred> {
  @override
  Widget build(BuildContext context) {
    allIngredientSelected.add(widget
        .dataDialBox); // add list from dialbox_add_ingredient to allIngredientSelected
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add ingredients'),
        ),
        body: Column(children: [
          // Votre contenu dans le Container de hauteur 200

          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50, top: 0),
            child: ListView.builder(
              itemCount: ingredientList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // UI
                  onLongPress: () {
                    Navigator.pushNamed(
                        context, '/dialbox_add_ingredient_and_quantity');
                  },
                  title: Text(ingredientList[index]),
                  // pour ajouter un contour au texet (attenion bug : le scroll prend toute la page)
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
              itemBuilder: (context, innerIndex) {
                return ListTile(
                  title: Text(allIngredientSelected.join(" ")),
                );
              },
            ),
          ),
        ]));
  }
}
