/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:io';

import 'package:Cooky/data/recipe_database/database.dart';
import 'package:Cooky/pages/add_category.dart';
import 'package:Cooky/pages/add_cost.dart';
import 'package:Cooky/pages/add_difficulty.dart';
import 'package:Cooky/pages/add_ingredients.dart';
import 'package:Cooky/pages/add_pics.dart';
import 'package:Cooky/pages/add_recipename.dart';
import 'package:Cooky/pages/add_tags.dart';
import 'package:Cooky/pages/add_totaltime.dart';
import 'package:Cooky/pages/create_steps.dart';
import 'package:Cooky/utils/dialbox_edit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:Cooky/pages/recipe_struct.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  // ignore: unused_field

  // load database
  final _myBox = Hive.box('mybox');
  // initiate databse instance :
  RecipeDatabase db = RecipeDatabase();

  List allIngredientSelectedCreateRecipe = [];
  String? pathImageSelectedFromImagePicker;
  List<String> stepsRecipeFromCreateSteps = [];
  late String recipeCategoryFromAddExistingCategory;
  String recipeNameFromAddRecipeName = "No title";
  String totalTimeFromAddTotalTime = "";
  String varFromAddDifficulty = "";
  String varFromAddCost = "";
  String previewImageTextField = "";
  String defautImage = "recipe_pics/no_image.png";
  List? tags = [];

  bool isButtonAddCategoryVisible = true;
  bool isButtonAddRecipeNameVisible = true;
  bool isButtonAddTotalTimeVisible = true;
  bool isButtonAddDifficultyVisible = true;
  bool isButtonAddCostVisible = true;
  bool isButtonAddPictureVisible = true;
  bool isButtonAddIngredVisible = true;
  bool isButtonAddStepsVisible = true;
  bool isFromScrap = false;
  bool isShowIngredientsSelectedPressed = false;
  bool isshowStepsAddedPressed = false;
  bool isButtonAddTagsVisible = true;
  bool isshowTagsAddedPressed = false;
  bool isFromEditRecipeStruct = false;
  bool _isConfirmBack = false;

  // dialbox error error if category is empty :
  void showDialogCategoryEmpty() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              AppLocalizations.of(context)!.categoryEmpty,
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

  ////// FUNCTIONS FOR RECIPE CATEGORY //////

  // get data from class AddExistingCategory()
  _getDataFromAddExistingCategory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExistingCategory(),
      ),
    );

    if (result != null) {
      String categoryName = result;

      setState(() {
        // Update visibility button

        isButtonAddCategoryVisible = false;
      });
      recipeCategoryFromAddExistingCategory = categoryName;
    }
  }

  // widget with button for adding category, and display category selected with edition button
  Widget addCategory(bool isButtonAddCategoryVisible) {
    setState(() {});
    return isButtonAddCategoryVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                _getDataFromAddExistingCategory(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addCategoryRequired,
                textAlign: TextAlign.center),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AppLocalizations.of(context)!.category,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                recipeCategoryFromAddExistingCategory,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  _getDataFromAddExistingCategory(context);
                },
                child: Icon(
                  Icons.create,
                  size: 30,
                ),
              ),
            ]),
          ]);
  }

  ////////////////////////////////////////////////////////

  ///////// FUNCTIONS FOR RECIPE NAME //////

  // get data from class AddRecipeName()
  void _getDataFromAddRecipeName(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecipeName(),
      ),
    );

    if (result != null) {
      String recipeName = result;

      setState(() {
        // Update visibility button

        isButtonAddRecipeNameVisible = false;
      });
      recipeNameFromAddRecipeName = recipeName;
    }
  }

  // widget with button for adding recipe name , and display recipe name selected with edition button
  Widget addRecipeName(bool isButtonAddRecipeNameVisible) {
    setState(() {});
    return isButtonAddRecipeNameVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                _getDataFromAddRecipeName(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addRecipeName),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AppLocalizations.of(context)!.recipeName,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                  // to have a limit if the text is too long (add ...)
                  width: 200,
                  child: Text(recipeNameFromAddRecipeName,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: recipeNameFromAddRecipeName ==
                              AppLocalizations.of(context)!.deleted
                          ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                          : TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      final result = await showDialog(
                          context: context,
                          builder: (context) {
                            return DialogEditRecipeField(
                              controller: TextEditingController(
                                  text: recipeNameFromAddRecipeName),
                              isFromScrap: false,
                              showSuggestion: () {
                                _getDataFromAddRecipeName(context);
                              },
                            );
                          });
                      if (result != null) {
                        String data = result;
                        setState(() {});
                        recipeNameFromAddRecipeName = data;
                      }
                    },
                    child: Icon(
                      Icons.create,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        recipeNameFromAddRecipeName =
                            AppLocalizations.of(context)!.deleted;
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
                  ),
                ],
              )
            ]),
          ]);
  }

  ////////////////////////////////////////////////////////
  ///
  ///
  //////////// FUNCTIONS FOR TOTAL TIME //////

  // get data from class AddTotalTime()
  void _getDataFromAddTotalTime(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTotalTime(),
      ),
    );

    if (result != null) {
      String totalTime = result;

      setState(() {
        // Update visibility button

        isButtonAddTotalTimeVisible = false;
      });
      totalTimeFromAddTotalTime = totalTime;
    }
  }

  // widget with button for adding total time , and display time selected with edition button
  Widget addTotalTime(bool isButtonAddtotalTimeVisible) {
    setState(() {});
    return isButtonAddtotalTimeVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                _getDataFromAddTotalTime(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addTotalTime),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AppLocalizations.of(context)!.totalTime,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(totalTimeFromAddTotalTime,
                  style: totalTimeFromAddTotalTime ==
                          AppLocalizations.of(context)!.deleted
                      ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                      : TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      final result = await showDialog(
                          context: context,
                          builder: (context) {
                            return DialogEditRecipeField(
                              controller: TextEditingController(
                                  text: totalTimeFromAddTotalTime),
                              isFromScrap: false,
                              showSuggestion: () {
                                _getDataFromAddTotalTime(context);
                              },
                            );
                          });
                      if (result != null) {
                        String data = result;
                        setState(() {});
                        totalTimeFromAddTotalTime = data;
                      }
                    },
                    child: Icon(
                      Icons.create,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        totalTimeFromAddTotalTime =
                            AppLocalizations.of(context)!.deleted;
                        Text(
                          totalTimeFromAddTotalTime,
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
                  ),
                ],
              )
            ]),
          ]);
  }

  ////////////////////////////////////////////////////////
  ///
  ///
  /// //////////// FUNCTIONS FOR DIFFICULTY //////

  // get data from class AddDifficulty()
  void _getDataFromAddDifficulty(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDifficulty(),
      ),
    );

    if (result != null) {
      String difficulty = result;

      setState(() {
        // Update visibility button

        isButtonAddDifficultyVisible = false;
      });
      varFromAddDifficulty = difficulty;
    }
  }

  // widget with button for adding difficulty , and display difficulty selected with edition button
  Widget addDifficulty(bool isButtonAddDifficulty) {
    setState(() {});
    return isButtonAddDifficulty
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                _getDataFromAddDifficulty(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addDifficulty),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AppLocalizations.of(context)!.difficulty,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(varFromAddDifficulty,
                  style: varFromAddDifficulty ==
                          AppLocalizations.of(context)!.deleted
                      ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                      : TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      final result = await showDialog(
                          context: context,
                          builder: (context) {
                            return DialogEditRecipeField(
                              controller: TextEditingController(
                                  text: varFromAddDifficulty),
                              isFromScrap: false,
                              showSuggestion: () {
                                _getDataFromAddDifficulty(context);
                              },
                            );
                          });
                      if (result != null) {
                        String data = result;
                        setState(() {});
                        varFromAddDifficulty = data;
                      }
                    },
                    child: Icon(
                      Icons.create,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        varFromAddDifficulty =
                            AppLocalizations.of(context)!.deleted;
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
                  ),
                ],
              )
            ]),
          ]);
  }

  ////////////////////////////////////////////////////////
  ///
  ////// //////////// FUNCTIONS FOR COST //////

  // get data from class AddCost()
  void _getDataFromAddCost(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCost(),
      ),
    );

    if (result != null) {
      String cost = result;

      setState(() {
        // Update visibility button

        isButtonAddCostVisible = false;
      });
      varFromAddCost = cost;
    }
  }

  // widget with button for adding cost , and display cost selected with edition button
  Widget addCost(bool isButtonAddCost) {
    setState(() {});
    return isButtonAddCost
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                _getDataFromAddCost(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addCost),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AppLocalizations.of(context)!.cost,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(varFromAddCost,
                  style: varFromAddCost == AppLocalizations.of(context)!.deleted
                      ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                      : TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      final result = await showDialog(
                          context: context,
                          builder: (context) {
                            return DialogEditRecipeField(
                              controller:
                                  TextEditingController(text: varFromAddCost),
                              isFromScrap: false,
                              showSuggestion: () {
                                _getDataFromAddCost(context);
                              },
                            );
                          });
                      if (result != null) {
                        String data = result;
                        setState(() {});
                        varFromAddCost = data;
                      }
                    },
                    child: Icon(
                      Icons.create,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        varFromAddCost = AppLocalizations.of(context)!.deleted;
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
                  ),
                ],
              )
            ]),
          ]);
  }

  ////////////////////////////////////////////////////////
  ///
  ///
  /// ////// //////////// FUNCTIONS FOR ADD PICTURE //////
  ///
  ///

  // function to display a dialog with picture preview
  void _showImagePreview(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: pathImageSelectedFromImagePicker != null
                ? Image.file(
                    File(pathImageSelectedFromImagePicker!),
                    width: 200,
                    height: 200,
                  )
                : Image.asset(
                    defautImage,
                    width: 200,
                    height: 200,
                  ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ],
          );
        });
  }

  // get picture from class MyImagePickerPage()
  void getDataFromMyImagePickerPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyImagePickerPage(),
      ),
    );

    if (result != null) {
      String imageSelected = result;
      setState(() {
        isButtonAddPictureVisible = false;
      });
      pathImageSelectedFromImagePicker = imageSelected;
    }
  }

  // widget with button for adding picture , and display preview  with edition button
  Widget addPicture(bool isButtonAddPictureVisible) {
    setState(() {});
    return isButtonAddPictureVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                getDataFromMyImagePickerPage(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addPicture),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AppLocalizations.of(context)!.picture,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                  onTap: () {
                    _showImagePreview(context);
                  },
                  child: Text(
                    previewImageTextField =
                        AppLocalizations.of(context)!.previewPicture,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      getDataFromMyImagePickerPage(context);
                    },
                    child: Icon(
                      Icons.create,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        pathImageSelectedFromImagePicker = null;
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
                  ),
                ],
              )
            ]),
          ]);
  }

  ////////////////////////////////////////////////////////
  ///
  ///

  /// ////// //////////// FUNCTIONS FOR ADD INGREDIENTS //////
  ///
  ///
  ///

  // function to edit ingredient
  editIngred(editName, editQuantity, editUnit, index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(10.0),
              content: Container(
                  height: 300,
                  child: Column(children: [
                    TextField(
                        controller: editName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: AppLocalizations.of(context)!.ingredName,
                        )),
                    TextField(
                        controller: editQuantity,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: AppLocalizations.of(context)!.quantity,
                        )),
                    TextField(
                        controller: editUnit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: AppLocalizations.of(context)!.unit,
                        ))
                  ])),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.add),
                      onPressed: () async {
                        allIngredientSelectedCreateRecipe[index][0] =
                            editName.text;
                        allIngredientSelectedCreateRecipe[index][1] =
                            editQuantity.text;
                        allIngredientSelectedCreateRecipe[index][2] =
                            editUnit.text;
                        Navigator.pop(context);

                        editName.clear();
                        editQuantity.clear();
                        editUnit.clear();
                        setState(() {});
                      },
                    )
                  ],
                )
              ]);
        });
  }

  // get  from class AddIngred()
  void getDataFromAddIngred(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddIngred(),
      ),
    );

    if (result != null) {
      List allIngredientSelected = result;
      setState(() {
        isButtonAddIngredVisible = false;
      });
      allIngredientSelectedCreateRecipe.addAll(allIngredientSelected);
    }
  }

  // widget with button for adding ingredients , and display preview  with edition button
  Widget addIngred(bool isButtonAddIngredVisible) {
    setState(() {});
    return isButtonAddIngredVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                getDataFromAddIngred(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addIngred),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            isShowIngredientsSelectedPressed
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        isShowIngredientsSelectedPressed = false;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.collapse,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          size: 16, // ajustez la taille selon vos besoins
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            getDataFromAddIngred(context);
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                            width: 16), // Ajustez cet espace selon vos besoins
                        InkWell(
                          onLongPress: () {
                            setState(() {
                              allIngredientSelectedCreateRecipe = [];
                            });
                          },
                          child: Icon(Icons.delete,
                              size: 20, color: Colors.redAccent),
                        ),
                      ],
                    ))
                : TextButton(
                    onPressed: () {
                      setState(() {
                        isShowIngredientsSelectedPressed = true;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.showIngred,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_upward,
                          size: 16, // ajustez la taille selon vos besoins
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            getDataFromAddIngred(context);
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                            width: 16), // Ajustez cet espace selon vos besoins
                        InkWell(
                          onLongPress: () {
                            setState(() {
                              allIngredientSelectedCreateRecipe = [];
                            });
                          },
                          child: Icon(Icons.delete,
                              size: 20, color: Colors.redAccent),
                        ),
                      ],
                    )),
          ]);
  }

  // widget list view to show all selected ingredient and possibilty to edit, delete
  Widget showIngredientsSelected() {
    setState(() {});
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 242, 255, 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        height: 400,
        child: ListView.builder(
          itemCount: allIngredientSelectedCreateRecipe.length,
          itemBuilder: (context, index) {
            final ingredient = allIngredientSelectedCreateRecipe[index][0];
            final quantity = allIngredientSelectedCreateRecipe[index][1];
            final unit = allIngredientSelectedCreateRecipe[index][2];

            final formattedString = '$ingredient : ($quantity$unit)';
            return ListTile(
              title: Text(formattedString),
              trailing: Wrap(
                spacing: -16,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      editIngred(
                          TextEditingController(
                              text: allIngredientSelectedCreateRecipe[index]
                                  [0]),
                          TextEditingController(
                              text: allIngredientSelectedCreateRecipe[index]
                                  [1]),
                          TextEditingController(
                              text: allIngredientSelectedCreateRecipe[index]
                                  [2]),
                          index);
                    },
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        allIngredientSelectedCreateRecipe.removeAt(index);
                      });
                    },
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
  ////////////////////////////////////////////////////////
  ///

  ///
  /// ////// //////////// FUNCTIONS FOR ADD STEPS //////
  ///
  ///

  // get  from class CreateSteps()
  void getDataFromCreateSteps(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSteps(),
      ),
    );

    if (result != null) {
      List<String> stepsRecipe = result;
      setState(() {
        isButtonAddStepsVisible = false;
      });
      stepsRecipeFromCreateSteps.addAll(stepsRecipe);
    }
  }

  // widget with button for adding steps , and display preview  with edition button
  Widget addSteps(bool isButtonAddStepsVisible) {
    setState(() {});
    return isButtonAddStepsVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                getDataFromCreateSteps(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addSteps),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            isshowStepsAddedPressed
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        isshowStepsAddedPressed = false;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.collapse,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          size: 16, // ajustez la taille selon vos besoins
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            getDataFromCreateSteps(context);
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                            width: 16), // Ajustez cet espace selon vos besoins
                        InkWell(
                          onLongPress: () {
                            setState(() {
                              stepsRecipeFromCreateSteps = [];
                            });
                          },
                          child: Icon(Icons.delete,
                              size: 20, color: Colors.redAccent),
                        ),
                      ],
                    ))
                : TextButton(
                    onPressed: () {
                      setState(() {
                        isshowStepsAddedPressed = true;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.showSteps,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_upward,
                          size: 16, // ajustez la taille selon vos besoins
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            getDataFromCreateSteps(context);
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                            width: 16), // Ajustez cet espace selon vos besoins
                        InkWell(
                          onLongPress: () {
                            setState(() {
                              stepsRecipeFromCreateSteps = [];
                            });
                          },
                          child: Icon(Icons.delete,
                              size: 20, color: Colors.redAccent),
                        ),
                      ],
                    )),
          ]);
  }

  // widget list view to show all steps and possibilty to edit, delete
  Widget showStepsAdded() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 242, 255, 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 400,
      child: ListView.builder(
        itemCount: stepsRecipeFromCreateSteps.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                '  ${AppLocalizations.of(context)!.step} ${index + 1}:\n${stepsRecipeFromCreateSteps[index]}'),
            trailing: Wrap(
              spacing: -16,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return DialogEditStep(
                            controller: TextEditingController(
                                text: stepsRecipeFromCreateSteps[index]
                                    .toString()),
                          );
                        });
                    if (result != null) {
                      String stepEdited = result;
                      setState(() {});
                      stepsRecipeFromCreateSteps[index] = stepEdited;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      stepsRecipeFromCreateSteps.removeAt(index);
                    });
                  },
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
  ////////////////////////////////////////////////////////
  ///
  /// ////// //////////// FUNCTIONS FOR ADD TAGS //////
  ///
  ///

  // get  from class AddTags()
  void getDataFromAddTags(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTags(),
      ),
    );

    if (result != null) {
      List data = result;
      setState(() {
        isButtonAddTagsVisible = false;
      });
      tags!.addAll(data);
    }
  }

  // widget with button for adding steps , and display preview  with edition button
  Widget addTags(bool isButtonAddTagsVisible) {
    setState(() {});
    return isButtonAddTagsVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                getDataFromAddTags(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addTags),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            isshowTagsAddedPressed
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        isshowTagsAddedPressed = false;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.collapse,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          size: 16, // ajustez la taille selon vos besoins
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            getDataFromAddTags(context);
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                            width: 16), // Ajustez cet espace selon vos besoins
                        InkWell(
                          onLongPress: () {
                            setState(() {
                              tags = [];
                            });
                          },
                          child: Icon(Icons.delete,
                              size: 20, color: Colors.redAccent),
                        ),
                      ],
                    ))
                : TextButton(
                    onPressed: () {
                      setState(() {
                        isshowTagsAddedPressed = true;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.showTags,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_upward,
                          size: 16, // ajustez la taille selon vos besoins
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            getDataFromAddTags(context);
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                            width: 16), // Ajustez cet espace selon vos besoins
                        InkWell(
                          onLongPress: () {
                            setState(() {
                              tags = [];
                            });
                          },
                          child: Icon(Icons.delete,
                              size: 20, color: Colors.redAccent),
                        ),
                      ],
                    )),
          ]);
  }

  // widget list view to show all steps and possibilty to edit, delete
  Widget showTagsAdded() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 242, 255, 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListView.builder(
        itemCount: tags!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${tags![index]}'),
            trailing: Wrap(
              spacing: -16,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return DialogEditStep(
                            controller: TextEditingController(
                                text: tags![index].toString()),
                          );
                        });
                    if (result != null) {
                      String data = result;
                      setState(() {});
                      tags![index] = data;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      tags!.removeAt(index);
                    });
                  },
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  ///
  ///
  ///
  /////// SHOW WIDGET WITH CONDITION : /////
  ///

  Widget ShowWidget() {
    setState(() {});
    if (isShowIngredientsSelectedPressed == false &&
        isshowStepsAddedPressed == false &&
        isshowTagsAddedPressed == false) {
      return Column(children: [
        addCategory(isButtonAddCategoryVisible),
        addRecipeName(isButtonAddRecipeNameVisible),
        addTotalTime(isButtonAddTotalTimeVisible),
        addDifficulty(isButtonAddDifficultyVisible),
        addCost(isButtonAddCostVisible),
        addPicture(isButtonAddPictureVisible),
        addIngred(isButtonAddIngredVisible),
        addSteps(isButtonAddStepsVisible),
        addTags(isButtonAddTagsVisible),
      ]);
    } else if (isShowIngredientsSelectedPressed == true) {
      return Column(children: [
        addIngred(isButtonAddIngredVisible),
        showIngredientsSelected()
      ]);
    } else if (isshowStepsAddedPressed == true) {
      return Column(children: [
        addSteps(isButtonAddStepsVisible),
        showStepsAdded(),
      ]);
    } else if (isshowTagsAddedPressed == true) {
      return Column(children: [
        addTags(isButtonAddTagsVisible),
        showTagsAdded(),
      ]);
    } else {
      return Text("Error, no widgets to display");
    }
  }

  // show dialog when back button pressed :
  Future<void> _showDialog() async {
    showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
                height: 200.0,
                child: Column(children: [
                  Text(AppLocalizations.of(context)!.areYouSureExit,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Center(
                      child: Text(AppLocalizations.of(context)!.saveEditLater,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic)))
                ])),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.confirmExit,
                    style: TextStyle(color: Colors.red)),
                onPressed: () {
                  setState(() {
                    // we can go back
                    _isConfirmBack = true;
                    // go back to tthe page before dialbox (create recipe)
                    Navigator.of(context).pop(_isConfirmBack);
                    // go back to the page before create recipe (home)
                    Navigator.of(context).pop();
                  });
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.no,
                    style: TextStyle(color: Colors.lightGreen)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // use WillPopScope for pop an alert dialog before exiting page. It works, but is deprecated
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createRecipe),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          canPop: _isConfirmBack,
          onPopInvoked: (bool didPop) async {
            if (didPop) {
              return;
            }
            _showDialog();
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: ListView(children: <Widget>[
              // SHOW RECIPE CATEGORY, RECIPE NAME ,TOTAL TIME ,DIFFICULTY, COST, ADD PICTURE, SELECT INGREDIENT, ADD STEPS OR SELECT INGREDIENT AND SHOW INGRED ADDED OR ADD STEPS AND SHOW STEPS:
              ShowWidget(),
            ])),
            // Button fot submit form
            if (isShowIngredientsSelectedPressed == false &&
                isshowStepsAddedPressed == false &&
                isshowTagsAddedPressed == false) ...[
              Container(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // handle deleted variable
                      final finalRecipeNameFromAddRecipeName =
                          recipeNameFromAddRecipeName ==
                                  AppLocalizations.of(context)!.deleted
                              ? AppLocalizations.of(context)!.noTitle
                              : recipeNameFromAddRecipeName;

                      final finalTotalTimeFromAddTotalTime =
                          totalTimeFromAddTotalTime ==
                                  AppLocalizations.of(context)!.deleted
                              ? ""
                              : totalTimeFromAddTotalTime;

                      final finalVarFromAddDifficulty = varFromAddDifficulty ==
                              AppLocalizations.of(context)!.deleted
                          ? ""
                          : varFromAddDifficulty;

                      final finalVarFromAddCost = varFromAddCost ==
                              AppLocalizations.of(context)!.deleted
                          ? ""
                          : varFromAddCost;

                      // create a varible with the date of creation
                      DateTime now = DateTime.now();
                      String creationDate =
                          'variable_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';

                      // retrieve database list
                      List listOfLists = _myBox.get('ALL_LISTS') ?? [];

                      // create null index for future add :
                      double? stars;
                      List? detailTIme;
                      List? utensils;

                      // Add a new list to the list of lists
                      try {
                        listOfLists.add([
                          finalRecipeNameFromAddRecipeName,
                          finalTotalTimeFromAddTotalTime,
                          finalVarFromAddDifficulty,
                          finalVarFromAddCost,
                          allIngredientSelectedCreateRecipe,
                          pathImageSelectedFromImagePicker,
                          stepsRecipeFromCreateSteps,
                          recipeCategoryFromAddExistingCategory,
                          isFromScrap,
                          creationDate,
                          tags,
                          stars,
                          detailTIme,
                          utensils,
                          null, // it's not an scrap image URL, so url is null
                          null, // not an url source scrap, so it's null
                        ]);
                      } catch (e) {
                        return showDialogCategoryEmpty();
                      }

                      // Update list of lists in Hive
                      _myBox.put('ALL_LISTS', listOfLists);

                      // check if required field category is missing :

                      // Create an instance of RecipeDetailsPage with the form data
                      RecipeStruct recipeDetailsPage = RecipeStruct(
                        recipeName: finalRecipeNameFromAddRecipeName,
                        totalTime: finalTotalTimeFromAddTotalTime,
                        difficulty: finalVarFromAddDifficulty,
                        cost: finalVarFromAddCost,
                        allIngredientSelected:
                            allIngredientSelectedCreateRecipe,
                        pathImageSelectedFromImagePicker:
                            pathImageSelectedFromImagePicker,
                        stepsRecipeFromCreateSteps: stepsRecipeFromCreateSteps,
                        isFromScrap: isFromScrap,
                        tags: tags,
                        uniqueId: creationDate,
                        recipeCategory: recipeCategoryFromAddExistingCategory,
                        isFromFilteredNameRecipe: false,
                        sourceUrlScrap: null,
                      );

                      // Navigate to the new page with the form data and save
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => recipeDetailsPage),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.add),
                  )),
            ]
          ]),
        ),
      ),
    );
  }
}
