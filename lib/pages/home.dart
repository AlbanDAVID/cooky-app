// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cook_app/pages/filtered_name_recipe.dart';
import 'package:cook_app/data/categories_database/categories_names.dart';
import 'package:cook_app/data/categories_database/categories_names_services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/recipe_database/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CategoriesNamesService _categoriesNamesService =
      CategoriesNamesService();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COOKY"),
        centerTitle: true,
        elevation: 0,
        //leading: const Icon(Icons.menu),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Column(children: [
        SizedBox(
            height: 500,
            child: ValueListenableBuilder(
              valueListenable: Hive.box<CategoriesNames>('catBox').listenable(),
              builder: (context, Box<CategoriesNames> box, _) {
                return Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: box.values.length,
                      itemBuilder: (context, index) {
                        var cat = box.getAt(index);
                        return TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilteredNameRecipe(
                                  categoryName: cat!.categoryName.toString(),
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.lightGreen, // Couleur du bouton
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20.0), // Bords arrondis
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
      ]),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 113, 153, 187),
        child: Column(children: [
          DrawerHeader(
              child: Icon(
            Icons.cookie,
            size: 48,
          )),
          // home page list tile
          ListTile(
            leading: Icon(Icons.home),
            title: Text("H O M E"),
          ),
          ListTile(
            leading: Icon(Icons.dining),
            title: Text("R E C I P E S"),
            onTap: () {
              Navigator.pushNamed(context, '/recipe');
            },
          ),
          ListTile(
            leading: Icon(Icons.trending_up),
            title: Text("S T A T S"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("S E T T I N G S"),
          )
        ]),
      ),

      // floatingActionButton for create a recipe:
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create_recipe');
        },
        label: const Text("Add delightful recipe"),
      ),
    );
  }
}
