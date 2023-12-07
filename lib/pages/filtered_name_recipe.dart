import 'package:cook_app/data/recipe_database/database.dart';
import 'package:cook_app/utils/edit_recipe.dart';
import 'package:cook_app/utils/recipe_struct.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilteredNameRecipe extends StatefulWidget {
  final String categoryName;
  const FilteredNameRecipe({Key? key, required this.categoryName})
      : super(key: key);

  @override
  State<FilteredNameRecipe> createState() => _FilteredNameRecipeState();
}

class _FilteredNameRecipeState extends State<FilteredNameRecipe> {
  final _myBox = Hive.box('mybox');
  RecipeDatabase db = RecipeDatabase();

  late final String finalEditRecipeName;

  bool isEditDeleteMode = false;

  late String _confirmationTextDeleteOneRecipe;

  late String _confirmationTextDeleteAllRecipe;

  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
      index) async {
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
          index: index,
          isFromScrap: isFromScrap,
          editPathImage: editPathImage,
          tags: tags,
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
    print(index);
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    recipeList.removeAt(index);
    _myBox.put("ALL_LISTS", recipeList);
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

  void filterList(String searchTerm) {
    setState(() {
      // Créez une nouvelle liste filtrée
      List<List> filteredList = [];

      for (int i = 0; i < db.recipeList.length; i++) {
        if (db.recipeList[i][7] == widget.categoryName &&
            db.recipeList[i][0]
                .toLowerCase()
                .contains(searchTerm.toLowerCase())) {
          // Ajoutez l'élément filtré à la nouvelle liste
          filteredList.add(db.recipeList[i]);
        }
      }

      // Mettez à jour db.recipeList avec la nouvelle liste filtrée
      db.recipeList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COOKY"),
        centerTitle: true,
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
          TextField(
            controller: _searchController,
            onChanged: (value) {
              filterList(value);
            },
            decoration: InputDecoration(
              hintText: 'Recherche...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
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
                    itemCount: db.recipeList.length,
                    itemBuilder: (context, index) {
                      if (db.recipeList[index][7] == widget.categoryName) {
                        return Column(
                          children: [
                            ListTile(
                              title: Center(
                                child: Text(
                                  db.recipeList[index][0],
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
                                              db.recipeList[index][4],
                                              db.recipeList[index][6],
                                              db.recipeList[index][7],
                                              db.recipeList[index][0],
                                              db.recipeList[index][1],
                                              db.recipeList[index][2],
                                              db.recipeList[index][3],
                                              db.recipeList[index][8],
                                              db.recipeList[index][5],
                                              db.recipeList[index][10],
                                              index,
                                            );
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
                              onTap: () {
                                setState(() {});
                                loadAllData();

                                RecipeStruct recipeInstance = RecipeStruct(
                                  recipeName: db.recipeList[index][0],
                                  totalTime: db.recipeList[index][1],
                                  difficulty: db.recipeList[index][2],
                                  cost: db.recipeList[index][3],
                                  allIngredientSelected: db.recipeList[index]
                                      [4],
                                  pathImageSelectedFromImagePicker:
                                      db.recipeList[index][5],
                                  stepsRecipeFromCreateSteps:
                                      db.recipeList[index][6],
                                  isFromScrap: db.recipeList[index][8],
                                  tags: db.recipeList[index][10],
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => recipeInstance,
                                  ),
                                );
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
    );
  }
}
