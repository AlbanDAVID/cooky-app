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

  // get recipe database
  final _myBox = Hive.box('mybox');
  RecipeDatabase db = RecipeDatabase();

  bool isEditDeleteMode = false;

  // function for handle click on popup menu
  void handleClick(int item) {
    switch (item) {
      case 0:
        setState(() {
          isEditDeleteMode = true;
        });
    }
  }

  // rename recipes categories after editing a category
  Future<void> renameCategoryRecipeAfterEditCategory(
      categoryNameToReplace, newCategoryName) async {
    // get all data
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    // Remove all the lists
    // iterate over the list in reverse order (because with normal order all the elements are not deleted)
    for (int i = recipeList.length - 1; i >= 0; i--) {
      if (recipeList[i][7].contains(categoryNameToReplace)) {
        recipeList[i][7] = newCategoryName;
      }
    }

    // Update the data in the box
    _myBox.put('ALL_LISTS', recipeList);
  }

  // delete all catagories and recipes

  void _dialogDeleteAll(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, 300, 0, 200),
              child: AlertDialog(
                title: Text('Deletion options'),

                content: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isEditDeleteMode = false;
                        });

                        await deleteAllRecipes();
                        Navigator.of(context).pop();
                      },
                      child: Text('Delete all recipes'),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isEditDeleteMode = false;
                        });

                        await deleteAllRecipesAndCategories();
                        Navigator.of(context).pop();
                      },
                      child: Text('Delete all recipes and categories'),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditDeleteMode = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Back'),
                  ),
                ],
                // Ajustez les valeurs selon vos besoins
              ));
        });
  }

  Future<void> deleteAllRecipes() async {
    // DELETE ALL DATA FROM mybox (where all recipe are saved) : //
    // get all data with recipes
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    // Remove all the list from recipelist
    // iterate over the list in reverse order (because with normal order all the elements are not deleted)
    recipeList = [];
    // Update the data in the box
    _myBox.put('ALL_LISTS', recipeList);
  }

  Future<void> deleteAllRecipesAndCategories() async {
    // DELETE ALL DATA FROM mybox (where all recipe are saved) : //
    await deleteAllRecipes();
    // DELETE ALL DATA FROM catBox (where all catagories names are saved) : //
    Hive.box<CategoriesNames>('catBox').clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("COOKY"),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: isEditDeleteMode
              ? <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      _dialogDeleteAll(context);
                    },
                    child: Text(
                      "Delete All",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        isEditDeleteMode = false;
                      });
                    },
                  ),
                ]
              : <Widget>[
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  PopupMenuButton<int>(
                    onSelected: (item) => handleClick(item),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(value: 0, child: Text('Edit/Delete')),
                    ],
                  ),
                ]),
      body: Column(children: [
        SizedBox(
            height: 500,
            child: ValueListenableBuilder(
              valueListenable: Hive.box<CategoriesNames>('catBox').listenable(),
              builder: (context, Box<CategoriesNames> box, _) {
                return Padding(
                    padding: EdgeInsets.all(100),
                    child: ListView.builder(
                      itemCount: box.values.length,
                      itemBuilder: (context, index) {
                        var cat = box.getAt(index);
                        return ListTile(
                          title: TextButton(
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
                          ),
                          trailing: isEditDeleteMode
                              ? Wrap(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        setState(() {
                                          isEditDeleteMode = false;
                                        });

                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Column(children: const [
                                                  Text('Edit category'),
                                                  Center(
                                                      child: Text(
                                                          'All recipes inside this category will get the new category name',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic)))
                                                ]),
                                                content: TextField(
                                                  controller: _controller,
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    child: Text('Edit'),
                                                    onPressed: () async {
                                                      var categoryNameToReplace =
                                                          cat!.categoryName;
                                                      var newCategoryName =
                                                          _controller.text;
                                                      var catName =
                                                          CategoriesNames(
                                                              _controller.text);
                                                      await Hive.box<
                                                                  CategoriesNames>(
                                                              'catBox')
                                                          .putAt(
                                                              index, catName);

                                                      await renameCategoryRecipeAfterEditCategory(
                                                          categoryNameToReplace,
                                                          newCategoryName);
                                                      Navigator.pop(context);
                                                      _controller.clear();
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                )
                              : null,
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
                          _controller.clear();
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
