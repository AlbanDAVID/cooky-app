// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cook_app/pages/filtered_name_recipe.dart';
import 'package:cook_app/data/categories_database/categories_names.dart';
import 'package:cook_app/data/categories_database/categories_names_services.dart';
import 'package:cook_app/utils/scraping.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/recipe_database/database.dart';
import 'package:marmiteur/marmiteur.dart';

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
  bool isFloatingActionButtonPressed = false;

  // data to send to Scraping class:
  late List<String> scrapStepsRecipe;
  late List scrapIngredient;
  late String scrapRecipeName;

  // function for handle click on popup menu
  void handleClick(int item) {
    switch (item) {
      case 0:
        setState(() {
          isEditDeleteMode = true;
        });

      case 1:
        setState(() {
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
                title: Column(children: const [
                  Text('Are you sure ?'),
                  Text('Confirm the desired option with a long press',
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic))
                ]),

                content: Column(
                  children: [
                    TextButton(
                      onLongPress: () async {
                        setState(() {
                          isEditDeleteMode = false;
                        });

                        await deleteAllRecipes();
                        Navigator.of(context).pop();
                      },
                      onPressed: () {},
                      child: Text('Delete all recipes',
                          style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onLongPress: () async {
                        setState(() {
                          isEditDeleteMode = false;
                        });

                        await deleteAllRecipesAndCategories();
                        Navigator.of(context).pop();
                      },
                      onPressed: () {},
                      child: Text('Delete all recipes and categories',
                          style: TextStyle(color: Colors.red)),
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
    deleteAllRecipes();
    // DELETE ALL DATA FROM catBox (where all catagories names are saved) : //
    Hive.box<CategoriesNames>('catBox').clear();
  }

  // function for delete a category and their recipes
  Future<void> deleteCategoryAndTheirRecipes(categoryName, index) async {
    // get all data with recipes :
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    // Remove all the lists with filtered name
    // iterate over the list in reverse order (because with normal order all the elements are not deleted)

    for (int i = recipeList.length - 1; i >= 0; i--) {
      if (recipeList[i][7].contains(categoryName)) {
        recipeList.removeAt(i);
      }
    }
    // Remove the category name :
    Hive.box<CategoriesNames>('catBox').deleteAt(index);
  }

  void _dialogDeleteOneCategory(BuildContext context, categoryName, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, 300, 0, 200),
              child: AlertDialog(
                title: Column(children: const [
                  Text('Are you sure ?'),
                  Text('Confirm the deletion with a long press',
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic))
                ]),
                content: TextButton(
                  onLongPress: () async {
                    setState(() {
                      isEditDeleteMode = false;
                    });
                    deleteCategoryAndTheirRecipes(categoryName, index);
                    Navigator.of(context).pop();
                  },
                  onPressed: () {},
                  child: Text(
                      'Yes, I want to delete this category and their recipes',
                      style: TextStyle(color: Colors.red)),
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

  // marmiteur
  void scrapMarmiteur(websiteURL) async {
    String recipeURL = websiteURL;
    var recipe = await marmiteur(recipeURL);

    scrapRecipeName = recipe['name'];
    scrapStepsRecipe = [];
    scrapIngredient = recipe["recipeIngredient"].cast<String>();
    // data cleaning by website :
    // retrieve website name :
    int startIndex = recipeURL.indexOf('.') + 1; // Index après le premier point
    int endIndex = recipeURL.indexOf(
        '.', startIndex); // Index du premier slash après le premier point

    String webSiteName = recipeURL.substring(startIndex, endIndex);

    // CUISINE AZ : //
    if (webSiteName == "cuisineaz") {
      // tranform dynamic list from scraper to a list of string
      scrapStepsRecipe = recipe['recipeInstructions'].cast<String>();
      // remove first element for ingredients because is is empty for cuisineaz
      scrapIngredient.removeAt(0);
    }

    // MARMITON : //
    // exatract each json steps
    if (webSiteName == "marmiton") {
      for (var i = 0; i < recipe['recipeInstructions'].length; i++) {
        var step = recipe["recipeInstructions"][i]["text"];

        scrapStepsRecipe.add(step);
      }
    }

    Scraping scrapInstance = Scraping(
        scrapRecipeName: scrapRecipeName,
        scrapStepsRecipe: scrapStepsRecipe,
        scrapAllIngredient: scrapIngredient);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => scrapInstance),
    );

    print(' step : $scrapStepsRecipe');
    print(' ingred : $scrapIngredient');
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
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                    PopupMenuButton<int>(
                      onSelected: (item) => handleClick(item),
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                            value: 0, child: Text('Edit/Delete')),
                        PopupMenuItem<int>(
                            value: 1, child: Text('Add a category'))
                      ],
                    ),
                  ]),
        body: Column(children: [
          SizedBox(
              height: 700,
              child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<CategoriesNames>('catBox').listenable(),
                builder: (context, Box<CategoriesNames> box, _) {
                  return Padding(
                      padding: EdgeInsets.all(0),
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
                                      categoryName:
                                          cat!.categoryName.toString(),
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(249, 246, 253, 0.49),
                                // Couleur du bouton
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Bords arrondis
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  cat!.categoryName,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
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
                                                  title:
                                                      Column(children: const [
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
                                                                _controller
                                                                    .text);
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
                                        onPressed: () {
                                          _dialogDeleteOneCategory(context,
                                              cat!.categoryName, index);
                                        },
                                      ),
                                    ],
                                  )
                                : null,
                          );
                        },
                      ));
                },
              )),
        ]),
        drawer: Drawer(
          backgroundColor: Color.fromRGBO(234, 221, 255, 1.000),
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
        floatingActionButton: isFloatingActionButtonPressed
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () async {
                      setState(() {
                        isFloatingActionButtonPressed = false;
                      });

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Column(children: const [
                                Text('Add from web (bêta)'),
                                Text(
                                    'Should work on marmiton.org, cuisineaz.com \n Will retireve : recipe name, ingredients ans steps',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic))
                              ]),
                              content: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  hintText: "Paste URL here",
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  child: Text('Add'),
                                  onPressed: () async {
                                    var recipeURL = _controller.text;
                                    scrapMarmiteur(recipeURL);
                                    Navigator.pop(context);
                                    _controller.clear();
                                  },
                                )
                              ],
                            );
                          });
                    },
                    label: Column(children: const [
                      Text('From web'),
                      Text(
                        '(bêta)',
                      )
                    ]),
                  ),
                  SizedBox(height: 16),
                  FloatingActionButton.extended(
                    onPressed: () {
                      setState(() {
                        isFloatingActionButtonPressed = false;
                      });
                      Navigator.pushNamed(context, '/create_recipe');
                    },
                    label: const Text("Manually"),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isFloatingActionButtonPressed = false;
                      });
                    },
                    child: Text("Back"),
                  )
                ],
              )
            : FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    isFloatingActionButtonPressed = true;
                  });
                },
                label: const Text("Add delightful recipe"),
              ));
  }
}
