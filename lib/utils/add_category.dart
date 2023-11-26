import 'package:cook_app/data/categories_database/categories_names.dart';
import 'package:cook_app/data/categories_database/categories_names_services.dart';
import 'package:cook_app/pages/filtered_name_recipe.dart';
import 'package:cook_app/utils/create_recipe.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddExistingCategory extends StatefulWidget {
  const AddExistingCategory({super.key});

  @override
  State<AddExistingCategory> createState() => _AddExistingCategoryState();
}

class _AddExistingCategoryState extends State<AddExistingCategory> {
  final CategoriesNamesService _categoriesNamesService =
      CategoriesNamesService();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add category"),
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
              child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<CategoriesNames>('catBox').listenable(),
                builder: (context, Box<CategoriesNames> box, _) {
                  return Padding(
                      padding: EdgeInsets.all(20),
                      child: ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          var cat = box.getAt(index);
                          return TextButton(
                            onPressed: () {
                              final String categoryName =
                                  cat!.categoryName.toString();
                              Navigator.pop(context, categoryName);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Colors.lightGreen, // Couleur du bouton
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Bords arrondis
                              ),
                            ),
                            child: Center(
                              child: Text(
                                cat!.categoryName,
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ));
                },
              )),
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add category'),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text('Add'),
                          onPressed: () async {
                            var catName = CategoriesNames(_controller.text);
                            await _categoriesNamesService.addCategory(catName);
                            Navigator.pop(context);
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
