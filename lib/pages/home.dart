/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:Cooky/pages/filtered_name_recipe.dart';
import 'package:Cooky/data/categories_database/categories_names.dart';
import 'package:Cooky/data/categories_database/categories_names_services.dart';
import 'package:Cooky/pages/recipe_struct.dart';
import 'package:Cooky/pages/scraping.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Cooky/data/recipe_database/database.dart';
import 'package:marmiteur/marmiteur.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool isSearchPressed = false;

  // data to send to Scraping class:
  late List<String> scrapStepsRecipe;
  late List scrapIngredient;
  late String scrapRecipeName;
  late String scrapTotalTime;
  late List scrapTags;
  late List scrapImage;

  // controller
  late TextEditingController _searchController;

  late List<dynamic> recipeListFilteredSearch;

  bool _isConfirmBack = false;
  bool scrapInstanceCreated = false;
  Map marmiteurResult = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchController = TextEditingController();

    loadAllData();
    recipeListFilteredSearch = db.recipeList;
  }

  // function to load recipe data
  loadAllData() {
    setState(() {
      db.loadData();
    });
  }

  // function for handle click on popup menu
  void handleClick(int item) {
    switch (item) {
      case 0:
        setState(() {
          isEditDeleteMode = true;
          _searchController.clear();
          isSearchPressed = false;
        });

      case 1:
        setState(() {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.addCategory),
                  content: TextField(
                    controller: _controller,
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.cancel),
                      onPressed: () async {
                        _controller.clear();
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.add),
                      onPressed: () async {
                        setState(() {
                          isEditDeleteMode = false;
                          _searchController.clear();
                          isSearchPressed = false;
                        });

                        if (_controller.text.trim().isNotEmpty) {
                          var catName = CategoriesNames(_controller.text);

                          await _categoriesNamesService.addCategory(catName);
                        } else {}
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
      if (recipeList[i][7] == categoryNameToReplace) {
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
              padding: EdgeInsetsDirectional.fromSTEB(0, 125, 0, 90),
              child: AlertDialog(
                title: Column(children: [
                  Text(AppLocalizations.of(context)!.areYouSure),
                  Text(AppLocalizations.of(context)!.confirmLongPress1,
                      textAlign: TextAlign.center,
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
                      child: Text(
                          AppLocalizations.of(context)!.deleteAllRecipes,
                          textAlign: TextAlign.center,
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
                      child: Text(
                          AppLocalizations.of(context)!
                              .deleteAllRecipesAndCategories,
                          textAlign: TextAlign.center,
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
                    child: Text(AppLocalizations.of(context)!.back),
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
      if (recipeList[i][7] == categoryName) {
        recipeList.removeAt(i);
      }
      _myBox.put('ALL_LISTS', recipeList);
    }
    // Remove the category name :
    Hive.box<CategoriesNames>('catBox').deleteAt(index);
  }

  void _dialogDeleteOneCategory(BuildContext context, categoryName, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, 200, 0, 100),
              child: AlertDialog(
                title: Column(children: [
                  Text(AppLocalizations.of(context)!.areYouSure,
                      textAlign: TextAlign.center),
                  Text(AppLocalizations.of(context)!.confirmLongPress1,
                      textAlign: TextAlign.center,
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
                      AppLocalizations.of(context)!.actionAfterLongPress1,
                      textAlign: TextAlign.center,
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
                    child: Text(AppLocalizations.of(context)!.back),
                  ),
                ],
                // Ajustez les valeurs selon vos besoins
              ));
        });
  }

  // display error marmiteur (dialbox)
  showDialogErrorMarmiteur() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              AppLocalizations.of(context)!.errorScrap,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // marmiteur
  scrapMarmiteur(websiteURL, {autoFormat = true}) async {
    // retrieve data from marmiteur

    String recipeURL = websiteURL;

    try {
      marmiteurResult = await marmiteur(recipeURL);
      if (marmiteurResult['name'] == null) {
        showDialogErrorMarmiteur();
      }
    } catch (e) {
      return e;
    }

    // create variables
    scrapRecipeName = marmiteurResult['name'];
    scrapStepsRecipe = marmiteurResult["recipeInstructions"].cast<String>();
    scrapIngredient = marmiteurResult["recipeIngredient"].cast<String>();
    scrapTotalTime = marmiteurResult["totalTime"];
    scrapTags = marmiteurResult["recipeCuisine"];

    // function to clean totalTime (remove prefix "PT" if any)
    String removePrefixPT(String scrapTotalTime) {
      if (scrapTotalTime.length >= 2 &&
          scrapTotalTime.substring(0, 2) == "PT") {
        return scrapTotalTime.substring(2);
      } else {
        return scrapTotalTime;
      }
    }

    // clean scrapTotalTime
    scrapTotalTime = removePrefixPT(scrapTotalTime);

    // initiate Scraping() class
    Scraping scrapInstance = Scraping(
      scrapRecipeName: scrapRecipeName,
      scrapStepsRecipe: scrapStepsRecipe,
      scrapAllIngredient: scrapIngredient,
      scrapTotalTime: scrapTotalTime,
      scrapTags: scrapTags,
      urlImageScrap: marmiteurResult["image"][0],
      sourceUrlScrap: recipeURL,
    );

    // send data to scrapInstance
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => scrapInstance),
    );
  }

  // function to search
  void filterList(String searchTerm) {
    setState(() {
      // Apply the search term to filter the list
      recipeListFilteredSearch = db.recipeList
          .where((recipe) =>
              recipe[0].toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  // show dialog when back button pressed :
  Future<void> _showDialog() async {
    showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 35.0,
              child: Text(AppLocalizations.of(context)!.quitAppConfirm,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.confirmExit,
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        setState(() {
                          // we can go back
                          _isConfirmBack = true;
                          // exit app
                          exit(0);
                        });
                      },
                    ),
                    SizedBox(
                        width:
                            8), // Ajoutez un espacement entre les boutons si nécessaire
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.no,
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          _showDialog();
        },
        child: Scaffold(
          backgroundColor: Color.fromRGBO(247, 242, 255, 1),
          appBar: AppBar(
              backgroundColor: Color.fromRGBO(247, 242, 255, 1),
              title: Text("Cooky",
                  style:
                      const TextStyle(color: Color.fromRGBO(147, 113, 202, 1))),
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
                          AppLocalizations.of(context)!.deleteAll,
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
                          onPressed: () {
                            setState(() {
                              isFloatingActionButtonPressed = false;
                              isSearchPressed = true;
                              loadAllData();
                            });
                          },
                          icon: const Icon(Icons.search)),
                      PopupMenuButton<int>(
                        onOpened: () {
                          setState(() {
                            isFloatingActionButtonPressed = false;
                          });
                        },
                        onSelected: (item) {
                          handleClick(item);
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(
                              value: 0,
                              child: Text(
                                  AppLocalizations.of(context)!.editDelete)),
                          PopupMenuItem<int>(
                              value: 1,
                              child: Text(
                                  AppLocalizations.of(context)!.addCategory))
                        ],
                      ),
                    ]),
          body: Hive.box<CategoriesNames>('catBox').isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.noRecipes,
                    style: TextStyle(color: Colors.blueGrey),
                  ))
              : Column(children: [
                  if (isSearchPressed == true) ...[
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        filterList(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  filterList('');
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  filterList('');
                                  isSearchPressed = false;
                                },
                                icon: const Icon(Icons.clear),
                              ),
                        hintText: AppLocalizations.of(context)!.searchRecipe,
                      ),
                    ),
                    if (_searchController.text != "")
                      Expanded(
                          child: ListView.builder(
                              itemCount: recipeListFilteredSearch.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Center(
                                    child: Text(
                                      recipeListFilteredSearch[index][0],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {});
                                    loadAllData();

                                    RecipeStruct recipeInstance = RecipeStruct(
                                      recipeName:
                                          recipeListFilteredSearch[index][0],
                                      totalTime: recipeListFilteredSearch[index]
                                          [1],
                                      difficulty:
                                          recipeListFilteredSearch[index][2],
                                      cost: recipeListFilteredSearch[index][3],
                                      allIngredientSelected:
                                          recipeListFilteredSearch[index][4],
                                      pathImageSelectedFromImagePicker:
                                          recipeListFilteredSearch[index][5],
                                      stepsRecipeFromCreateSteps:
                                          recipeListFilteredSearch[index][6],
                                      isFromScrap:
                                          recipeListFilteredSearch[index][8],
                                      tags: recipeListFilteredSearch[index][10],
                                      uniqueId: recipeListFilteredSearch[index]
                                          [9],
                                      recipeCategory:
                                          recipeListFilteredSearch[index][7],
                                      isFromFilteredNameRecipe: false,
                                      urlImageScrap:
                                          recipeListFilteredSearch[index][14],
                                      sourceUrlScrap:
                                          recipeListFilteredSearch[index][15],
                                    );

                                    // to display all list after editing (and not only the list from filter search)
                                    loadAllData();
                                    recipeListFilteredSearch = db.recipeList;
                                    _searchController.clear();
                                    isSearchPressed = false;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => recipeInstance,
                                      ),
                                    );
                                  },
                                );
                              }))
                  ],
                  if (isSearchPressed == false) ...[
                    SizedBox(
                        height: 500,
                        child: ValueListenableBuilder(
                          valueListenable:
                              Hive.box<CategoriesNames>('catBox').listenable(),
                          builder: (context, Box<CategoriesNames> box, _) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: ReorderableListView(
                                  onReorder: (int oldIndex, int newIndex) {
                                    setState(() {
                                      if (oldIndex < newIndex) {
                                        newIndex--;
                                      }

                                      final oldItem =
                                          Hive.box<CategoriesNames>('catBox')
                                              .getAt(oldIndex);
                                      final newItem =
                                          Hive.box<CategoriesNames>('catBox')
                                              .getAt(newIndex);
                                      Hive.box<CategoriesNames>('catBox')
                                          .putAt(oldIndex, newItem!);
                                      Hive.box<CategoriesNames>('catBox')
                                          .putAt(newIndex, oldItem!);
                                    });
                                  },
                                  children: <Widget>[
                                    for (int index = 0;
                                        index <
                                            Hive.box<CategoriesNames>('catBox')
                                                .length;
                                        index += 1)
                                      ListTile(
                                        key: Key('$index'),
                                        title: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FilteredNameRecipe(
                                                  categoryName: box
                                                      .getAt(index)!
                                                      .categoryName
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Center(
                                              child: Column(children: [
                                            Chip(
                                                label: Text(
                                              textAlign: TextAlign.center,
                                              box.getAt(index)!.categoryName,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromRGBO(
                                                      147, 113, 202, 1)),
                                            )),
                                          ])),
                                        ),
                                        trailing: isEditDeleteMode
                                            ? Wrap(
                                                children: [
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    onPressed: () async {
                                                      setState(() {
                                                        isEditDeleteMode =
                                                            false;
                                                        _searchController
                                                            .clear();
                                                        isSearchPressed = false;
                                                      });

                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Column(
                                                                  children: [
                                                                    Text(
                                                                        AppLocalizations.of(context)!
                                                                            .editCategory,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                    Center(
                                                                        child: Text(
                                                                            AppLocalizations.of(context)!
                                                                                .infoMessage1,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)))
                                                                  ]),
                                                              content:
                                                                  TextField(
                                                                controller:
                                                                    _controller,
                                                              ),
                                                              actions: [
                                                                ElevatedButton(
                                                                  child: Text(
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .cancel),
                                                                  onPressed:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      isSearchPressed =
                                                                          false;
                                                                      _controller
                                                                          .clear();
                                                                    });

                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                ElevatedButton(
                                                                  child: Text(
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .edit),
                                                                  onPressed:
                                                                      () async {
                                                                    var categoryNameToReplace = box
                                                                        .getAt(
                                                                            index)!
                                                                        .categoryName;
                                                                    var newCategoryName =
                                                                        _controller
                                                                            .text;
                                                                    if (_controller
                                                                        .text
                                                                        .trim()
                                                                        .isNotEmpty) {
                                                                      var catName =
                                                                          CategoriesNames(
                                                                              _controller.text);
                                                                      await Hive.box<CategoriesNames>('catBox').putAt(
                                                                          index,
                                                                          catName);
                                                                    }

                                                                    await renameCategoryRecipeAfterEditCategory(
                                                                        categoryNameToReplace,
                                                                        newCategoryName);
                                                                    Navigator.pop(
                                                                        context);
                                                                    _controller
                                                                        .clear();
                                                                    _searchController
                                                                        .clear();
                                                                    isSearchPressed =
                                                                        false;
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
                                                      _dialogDeleteOneCategory(
                                                          context,
                                                          box
                                                              .getAt(index)!
                                                              .categoryName
                                                              .toString(),
                                                          index);
                                                      _searchController.clear();
                                                      isSearchPressed = false;
                                                    },
                                                  ),
                                                ],
                                              )
                                            : null,
                                      ),
                                  ],
                                ));
                          },
                        )),
                  ]
                ]),
          drawer: Drawer(
            backgroundColor: Color.fromRGBO(234, 221, 255, 1.000),
            child: Column(children: [
              DrawerHeader(
                  child: Image.asset(
                "android/app/src/main/res/mipmap-hdpi/ic_launcher.png",
              )),
              // home page list tile
              ListTile(
                leading: Icon(Icons.home),
                title: Text(AppLocalizations.of(context)!.home),
                onTap: () {
                  _searchController.clear();
                  isSearchPressed = false;
                  Navigator.popAndPushNamed(context, '/home');
                },
              ),
              ListTile(
                leading: Icon(Icons.language_sharp),
                title: Text(AppLocalizations.of(context)!.language),
                onTap: () {
                  _searchController.clear();
                  isSearchPressed = false;
                  Navigator.popAndPushNamed(context, '/language');
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(AppLocalizations.of(context)!.about),
                onTap: () {
                  _searchController.clear();
                  isSearchPressed = false;
                  Navigator.popAndPushNamed(context, '/about');
                },
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
                          _searchController.clear();
                          isSearchPressed = false;
                        });

                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text(
                                      AppLocalizations.of(context)!.addFromWeb),
                                  content: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText:
                                          AppLocalizations.of(context)!.pastUrl,
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .cancel),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            _controller.clear();
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .add),
                                          onPressed: () async {
                                            var recipeURL = _controller.text;
                                            scrapMarmiteur(recipeURL);
                                            Navigator.pop(context);
                                            _controller.clear();
                                          },
                                        )
                                      ],
                                    )
                                  ]);
                            });
                      },
                      label: Text(AppLocalizations.of(context)!.addFromWeb),
                    ),
                    SizedBox(height: 16),
                    FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          isFloatingActionButtonPressed = false;
                          _searchController.clear();
                          isSearchPressed = false;
                        });
                        Navigator.pushNamed(context, '/create_recipe');
                      },
                      label: Text(AppLocalizations.of(context)!.create),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isFloatingActionButtonPressed = false;
                          _searchController.clear();
                          isSearchPressed = false;
                        });
                      },
                      child: Text(AppLocalizations.of(context)!.back),
                    )
                  ],
                )
              : FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      isFloatingActionButtonPressed = true;
                      _searchController.clear();
                      isSearchPressed = false;
                    });
                  },
                  label:
                      Text(AppLocalizations.of(context)!.addDelightfulRecipe),
                ),
        ));
  }
}
