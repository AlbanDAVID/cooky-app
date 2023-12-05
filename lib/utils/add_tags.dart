// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTags extends StatefulWidget {
  const AddTags({super.key});

  @override
  State<AddTags> createState() => _AddTagsState();
}

class _AddTagsState extends State<AddTags> {
  final List tagsEnglish = [
    "Appetizer",
    "Healthy",
    "Starter",
    "Main Course",
    "Dessert",
    "Vegetarian",
    "Vegan",
    "Gluten-Free",
    "Easy",
    "Quick",
    "Healthy",
    "Indulgent",
    "Spicy",
    "Sweet",
    "Savory",
    "Balanced",
    "Traditional",
    "Fusion",
    "Exotic",
    "Comfort Food",
    "Light",
    "Grilled",
    "Baked",
    "Fish",
    "Meat",
    "Chicken",
    "Beef",
    "Pork",
    "Vegetables",
    "Pasta",
    "Rice",
    "Soup",
    "Salad",
    "Sandwich",
    "Breakfast",
    "Brunch",
    "Dinner",
    "Party",
    "Family Meal",
    "Friends Gathering",
    "Picnic",
  ];

  final List tagsFrench = [
    "Apéritif",
    "Healthy",
    "Entrée",
    "Plat Principal",
    "Dessert",
    "Végétarien",
    "Végétalien",
    "Sans Gluten",
    "Facile",
    "Rapide",
    "Sain",
    "Gourmand",
    "Épicé",
    "Sucré",
    "Salé",
    "Équilibré",
    "Traditionnel",
    "Fusion",
    "Exotique",
    "Comfort Food",
    "Léger",
    "Grillade",
    "Cuisson au Four",
    "Poisson",
    "Viande",
    "Poulet",
    "Boeuf",
    "Porc",
    "Légumes",
    "Pâtes",
    "Riz",
    "Soupe",
    "Salade",
    "Sandwich",
    "Petit-déjeuner",
    "Brunch",
    "Dîner",
    "Fête",
    "Repas en Famille",
    "Repas entre Amis",
    "Picnic",
  ];

  final List selectedTags = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // add list from dialbox_add_ingredient to allIngredientSelected
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add tags'),
        ),
        body: Column(children: [
          const Text("Suggestions : ", style: TextStyle(fontSize: 13)),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50, top: 0),
            child: ListView.builder(
              itemCount: tagsEnglish.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTags.add(
                        tagsEnglish[index],
                      );
                    });
                  },
                  child: Text(
                    tagsEnglish[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ));
              },
            ),
          )),
          Expanded(
            child: ListView.builder(
              itemCount: selectedTags.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text('${selectedTags[index]}'),
                    trailing: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          selectedTags.removeAt(index);
                        });
                      },
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {},
                      ),
                    ));
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.addTag),
                      content: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: AppLocalizations.of(context)!.writeTag,
                          )),
                      actions: [
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.add),
                          onPressed: () async {
                            selectedTags.add(
                              _controller.text,
                            );
                            Navigator.pop(context);

                            _controller.clear();

                            setState(() {});
                          },
                        )
                      ],
                    );
                  });
            },
            child: Icon(Icons.add),
          ),
          Container(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedTags);
                },
                child: Text(AppLocalizations.of(context)!.add),
              ))
        ]));
  }
}
