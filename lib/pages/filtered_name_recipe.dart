import 'package:cook_app/data/recipe_database/database.dart';
import 'package:cook_app/pages/home.dart';
import 'package:cook_app/utils/edit_recipe.dart';
import 'package:cook_app/utils/recipe_struct.dart';
import 'package:cook_app/utils/search_bar_UI.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilteredNameRecipe extends StatefulWidget {
  final String categoryName;
  const FilteredNameRecipe({super.key, required this.categoryName});

  @override
  State<FilteredNameRecipe> createState() => _FilteredNameRecipeState();
}

class _FilteredNameRecipeState extends State<FilteredNameRecipe> {
  final _myBox = Hive.box('mybox');
  RecipeDatabase db = RecipeDatabase();

  late final String finalEditRecipeName;

  bool isEditDeleteMode = false;
  bool isSearchPressed = false;

  late String _confirmationTextDeleteOneRecipe;

  late String _confirmationTextDeleteAllRecipe;

  late TextEditingController _searchController;

  late List<dynamic> recipeListFilteredSearch;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    loadAllData();
    recipeListFilteredSearch = db.recipeList;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _confirmationTextDeleteOneRecipe =
        AppLocalizations.of(context)!.confirmLongPress2;
    _confirmationTextDeleteAllRecipe =
        AppLocalizations.of(context)!.confirmLongPress3;
  }

  // function to load data
  loadAllData() {
    setState(() {
      db.loadData();
    });
  }

  void sendDataToEditAtEditRecipe(
      BuildContext context,
      editAllIngredient,
      editStepsRecipe,
      editRecipeCategory,
      editRecipeName,
      editTotalTime,
      editDifficulty,
      editCost,
      isFromScrap,
      editPathImage,
      tags,
      uniqueId,
      editUrlScrap) async {
    // for final result await, in fact we could send antoher variable, it's to force filtered_name_recipe to rebuild again and take in count the new recipe name
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipe(
          editAllIngredient: editAllIngredient,
          editStepsRecipe: editStepsRecipe,
          editRecipeCategory: editRecipeCategory,
          editRecipeName: editRecipeName,
          editTotalTime: editTotalTime,
          editDifficulty: editDifficulty,
          editCost: editCost,
          uniqueId: uniqueId,
          isFromScrap: isFromScrap,
          editPathImage: editPathImage,
          tags: tags,
          editUrlImageScrap: editUrlScrap,
        ),
      ),
    );

    if (result != null) {
      String editRecipeName = result;
      print('Received data from SecondScreen: $editRecipeName');
      setState(() {});
      finalEditRecipeName = editRecipeName;
    }
  }

  void deleteOneRecipe(index) {
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    for (int i = 0; i < recipeList.length; i++) {
      if (recipeListFilteredSearch[index][9] == db.recipeList[i][9]) {
        recipeList.removeAt(i);
      }
    }
    _myBox.put('ALL_LISTS', recipeList);
  }

  void deleteAllRecipe(myBox) {
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    for (int i = recipeList.length - 1; i >= 0; i--) {
      if (recipeList[i][7] == widget.categoryName) {
        recipeList.removeAt(i);
      }
    }
    _myBox.put('ALL_LISTS', recipeList);
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        setState(() {
          isEditDeleteMode = true;
        });
    }
  }

  void _dialogDelete(BuildContext context, String confirmText, deleteFunction,
      {index}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, 200, 0, 100),
              child: AlertDialog(
                title: Column(children: [
                  Text(AppLocalizations.of(context)!.areYouSure),
                  Text(AppLocalizations.of(context)!.confirmLongPress4,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic))
                ]),
                content: TextButton(
                  onLongPress: () {
                    setState(() {
                      isEditDeleteMode = false;
                      deleteFunction(index);
                    });

                    Navigator.of(context).pop();
                    setState(() {
                      loadAllData();
                      recipeListFilteredSearch = db.recipeList;
                      _searchController.clear();

                      isSearchPressed = false;
                    });
                  },
                  onPressed: () {},
                  child: Text(confirmText,
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
              ));
        });
  }

  // function to search
  void filterList(String searchTerm) {
    setState(() {
      // Apply the search term to filter the list
      recipeListFilteredSearch = db.recipeList
          .where((recipe) =>
              recipe[7] == widget.categoryName &&
              recipe[0].toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.recipes),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: isEditDeleteMode
                ? <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _dialogDelete(
                          context,
                          _confirmationTextDeleteAllRecipe,
                          deleteAllRecipe,
                        );
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
                            isSearchPressed = true;
                          });
                        },
                        icon: const Icon(Icons.search)),
                    PopupMenuButton<int>(
                      onSelected: (item) => handleClick(item),
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text(AppLocalizations.of(context)!.editDelete),
                        ),
                      ],
                    ),
                  ],
          ),
          body: Column(
            children: [
              if (isSearchPressed == true)
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
                    )),
              Expanded(
                child: FutureBuilder(
                  future: loadAllData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Erreur: ${snapshot.error}');
                    } else {
                      return ListView.builder(
                        itemCount: recipeListFilteredSearch.length,
                        itemBuilder: (context, index) {
                          if (recipeListFilteredSearch[index][7] ==
                              widget.categoryName) {
                            return Column(
                              children: [
                                ListTile(
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
                                  trailing: isEditDeleteMode
                                      ? Wrap(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                setState(() {
                                                  isEditDeleteMode = false;
                                                });

                                                sendDataToEditAtEditRecipe(
                                                    context,
                                                    recipeListFilteredSearch[
                                                        index][4],
                                                    recipeListFilteredSearch[
                                                        index][6],
                                                    recipeListFilteredSearch[
                                                        index][7],
                                                    recipeListFilteredSearch[
                                                        index][0],
                                                    recipeListFilteredSearch[
                                                        index][1],
                                                    recipeListFilteredSearch[
                                                        index][2],
                                                    recipeListFilteredSearch[
                                                        index][3],
                                                    recipeListFilteredSearch[
                                                        index][8],
                                                    recipeListFilteredSearch[
                                                        index][5],
                                                    recipeListFilteredSearch[
                                                        index][10],
                                                    recipeListFilteredSearch[
                                                        index][9],
                                                    recipeListFilteredSearch[
                                                        index][14]);

                                                // to display all list after editing (and not only the list from filter search)
                                                loadAllData();
                                                recipeListFilteredSearch =
                                                    db.recipeList;

                                                setState(() {
                                                  _searchController.clear();

                                                  isSearchPressed = false;
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () {
                                                _dialogDelete(
                                                  context,
                                                  _confirmationTextDeleteOneRecipe,
                                                  deleteOneRecipe,
                                                  index: index,
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      : null,
                                  onTap: () async {
                                    setState(() {});
                                    loadAllData();

                                    RecipeStruct recipeInstance = RecipeStruct(
                                        recipeName:
                                            recipeListFilteredSearch[index][0],
                                        totalTime:
                                            recipeListFilteredSearch[index][1],
                                        difficulty:
                                            recipeListFilteredSearch[index][2],
                                        cost: recipeListFilteredSearch[index]
                                            [3],
                                        allIngredientSelected:
                                            recipeListFilteredSearch[index][4],
                                        pathImageSelectedFromImagePicker:
                                            recipeListFilteredSearch[index][5],
                                        stepsRecipeFromCreateSteps:
                                            recipeListFilteredSearch[index][6],
                                        isFromScrap:
                                            recipeListFilteredSearch[index][8],
                                        tags: recipeListFilteredSearch[index]
                                            [10],
                                        uniqueId:
                                            recipeListFilteredSearch[index][9],
                                        recipeCategory:
                                            recipeListFilteredSearch[index][7],
                                        isFromFilteredNameRecipe: true,
                                        urlImageScrap: recipeListFilteredSearch[index][14],
                                        sourceUrlScrap: recipeListFilteredSearch[index][15]);

                                    // to display all list after display a recipe (and not only the list from filter search)
                                    loadAllData();
                                    recipeListFilteredSearch = db.recipeList;
                                    setState(() {
                                      _searchController.clear();

                                      isSearchPressed = false;
                                    });

                                    // wait a value to force rebuild page after display the recipe :
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => recipeInstance,
                                      ),
                                    );

                                    if (result != null) {
                                      String refresh = result;
                                      print(
                                          'Received data from SecondScreen: $refresh');
                                      setState(() {});
                                    }
                                  },
                                ),
                                Divider(
                                  height: 50,
                                  color: Colors.grey,
                                  indent: 50,
                                  endIndent: 50,
                                  thickness: 0.40,
                                ),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
