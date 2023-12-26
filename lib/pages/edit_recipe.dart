/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// ignore_for_file: prefer_const_constructors

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

// ignore: must_be_immutable
class EditRecipe extends StatefulWidget {
  List editAllIngredient;
  String? editPathImage;
  List<String> editStepsRecipe;
  String editRecipeCategory;
  String editRecipeName;
  String editTotalTime;
  String editDifficulty;
  String editCost;
  bool isFromScrap;
  List? tags;
  String uniqueId;
  String? editUrlImageScrap;

  EditRecipe(
      {super.key,
      required this.editAllIngredient,
      this.editPathImage,
      required this.editStepsRecipe,
      required this.editRecipeCategory,
      required this.editRecipeName,
      required this.editTotalTime,
      required this.editDifficulty,
      required this.editCost,
      required this.isFromScrap,
      this.tags,
      required this.uniqueId,
      this.editUrlImageScrap});

  @override
  // ignore: library_private_types_in_public_api
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  // ignore: unused_field

  // load database
  final _myBox = Hive.box('mybox');
  // initiate databse instance :
  RecipeDatabase db = RecipeDatabase();

  String previewImageTextField = "";

  bool isShowIngredientsSelectedPressed = false;
  bool isshowStepsAddedPressed = false;
  bool isshowTagsAddedPressed = false;
  bool _isConfirmBack = false;

  String defautImage = "recipe_pics/no_image.png";

  // function to get index of the list to edit
  getIndex() {
    loadAllData();
    for (int i = 0; i < db.recipeList.length; i++) {
      if (db.recipeList[i][9] == widget.uniqueId) {
        return i;
      }
    }
  }

// function to load data
  loadAllData() {
    setState(() {
      db.loadData();
    });
  }

  ////// FUNCTIONS FOR RECIPE CATEGORY //////

  // get data from class AddExistingCategory()
  void _getDataFromAddExistingCategory(BuildContext context) async {
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
      });
      widget.editRecipeCategory = categoryName;
    }
  }

  // widget with button for adding category, and display category selected with edition button
  Widget addCategory() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.category,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          widget.editRecipeCategory,
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
      });
      widget.editRecipeName = recipeName;
    }
  }

  // widget with button for adding recipe name , and display recipe name selected with edition button
  Widget addRecipeName() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            child: Text(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              widget.editRecipeName,
              style:
                  widget.editRecipeName == AppLocalizations.of(context)!.deleted
                      ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                      : TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
            )),
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
                            TextEditingController(text: widget.editRecipeName),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddRecipeName(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.editRecipeName = data;
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
                  widget.editRecipeName = AppLocalizations.of(context)!.deleted;
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
      });
      widget.editTotalTime = totalTime;
    }
  }

  // widget with button for adding total time , and display time selected with edition button
  Widget addTotalTime() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.totalTime,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.editTotalTime,
            style: widget.editTotalTime == AppLocalizations.of(context)!.deleted
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
                            TextEditingController(text: widget.editTotalTime),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddTotalTime(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.editTotalTime = data;
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
                  widget.editTotalTime = AppLocalizations.of(context)!.deleted;
                  Text(
                    widget.editTotalTime,
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
      });
      widget.editDifficulty = difficulty;
    }
  }

  // widget with button for adding difficulty , and display difficulty selected with edition button
  Widget addDifficulty() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.difficulty,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.editDifficulty,
            style:
                widget.editDifficulty == AppLocalizations.of(context)!.deleted
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
                            TextEditingController(text: widget.editDifficulty),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddDifficulty(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.editDifficulty = data;
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
                  widget.editDifficulty = AppLocalizations.of(context)!.deleted;
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
      });
      widget.editCost = cost;
    }
  }

  // widget with button for adding cost , and display cost selected with edition button
  Widget addCost() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.cost,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.editCost,
            style: widget.editCost == AppLocalizations.of(context)!.deleted
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
                            TextEditingController(text: widget.editCost),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddCost(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.editCost = data;
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
                  widget.editCost = AppLocalizations.of(context)!.deleted;
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
  ///

  // function to decide image to display
  _imageToDisplay() {
    if (widget.editUrlImageScrap != null) {
      return Image.network(
        widget.editUrlImageScrap!,
        width: 200,
        height: 200,
      );
    } else if (widget.editPathImage != null) {
      return Image.file(
        File(widget.editPathImage!),
        width: 200,
        height: 200,
      );
    } else if (widget.editUrlImageScrap == null &&
        widget.editPathImage == null) {
      return Image.asset(
        defautImage,
        width: 200,
        height: 200,
      );
    }
  }

  // function to display a dialog with picture preview
  void _showImagePreview(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: _imageToDisplay(),
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
      setState(() {});

      widget.editPathImage = imageSelected;
      widget.editUrlImageScrap = null;
    }
  }

  // widget with button for adding picture , and display preview  with edition button
  Widget addPicture() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  widget.editPathImage = null;
                  widget.editUrlImageScrap = null;
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
                        widget.editAllIngredient[index][0] = editName.text;
                        widget.editAllIngredient[index][1] = editQuantity.text;
                        widget.editAllIngredient[index][2] = editUnit.text;
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

  // get  from class AddIngred() (for isFromScrap = false)
  void getDataFromAddIngred(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddIngred(),
      ),
    );

    if (result != null) {
      List allIngredientSelected = result;
      setState(() {});
      widget.editAllIngredient.addAll(allIngredientSelected);
    }
  }

  // widget with button for adding ingredients , and display preview  with edition button
  Widget addIngred() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    onTap: widget.isFromScrap
                        ? () async {
                            final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogEditStep(
                                    controller: TextEditingController(text: ""),
                                  );
                                });
                            if (result != null) {
                              String addedIngredScrap = result;
                              setState(() {});
                              widget.editAllIngredient.add(addedIngredScrap);
                            }
                          }
                        : () {
                            getDataFromAddIngred(context);
                          },
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.editAllIngredient = [];
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
                    onTap: widget.isFromScrap
                        ? () async {
                            final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogEditStep(
                                    controller: TextEditingController(text: ""),
                                  );
                                });
                            if (result != null) {
                              String addedIngredScrap = result;
                              setState(() {});
                              widget.editAllIngredient.add(addedIngredScrap);
                            }
                          }
                        : () {
                            getDataFromAddIngred(context);
                          },
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.editAllIngredient = [];
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
                  ),
                ],
              )),
    ]);
  }

  // widget list view to show all selected ingredient and possibilty to edit, delete
  Widget showIngredientsSelected() {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 242, 255, 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        height: 400,
        child: ListView.builder(
          itemCount: widget.editAllIngredient.length,
          itemBuilder: (context, index) {
            final ingredient = widget.editAllIngredient[index][0];
            final quantity = widget.editAllIngredient[index][1];
            final unit = widget.editAllIngredient[index][2];

            final formattedString = '$ingredient : ($quantity$unit)';
            return ListTile(
              title: widget.isFromScrap
                  ? Text(widget.editAllIngredient[index])
                  : Text(formattedString),
              trailing: Wrap(
                spacing: -16,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: widget.isFromScrap
                        ? () async {
                            final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogEditStep(
                                      controller: TextEditingController(
                                    text: widget.editAllIngredient[index]
                                        .toString(),
                                  ));
                                });
                            if (result != null) {
                              String addedIngredScrap = result;
                              setState(() {});
                              widget.editAllIngredient[index] =
                                  addedIngredScrap;
                            }
                          }
                        : () {
                            editIngred(
                                TextEditingController(
                                    text: widget.editAllIngredient[index][0]),
                                TextEditingController(
                                    text: widget.editAllIngredient[index][1]),
                                TextEditingController(
                                    text: widget.editAllIngredient[index][2]),
                                index);
                          },
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        widget.editAllIngredient.removeAt(index);
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
      setState(() {});
      widget.editStepsRecipe.addAll(stepsRecipe);
    }
  }

  // widget with button for adding steps , and display preview  with edition button
  Widget addSteps() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.editStepsRecipe = [];
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.editStepsRecipe = [];
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
        itemCount: widget.editStepsRecipe.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                ' ${AppLocalizations.of(context)!.step} ${index + 1}:\n${widget.editStepsRecipe[index]}'),
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
                                text: widget.editStepsRecipe[index].toString()),
                          );
                        });
                    if (result != null) {
                      String stepEdited = result;
                      setState(() {});
                      widget.editStepsRecipe[index] = stepEdited;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      widget.editStepsRecipe.removeAt(index);
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
      setState(() {});
      widget.tags!.addAll(data);
    }
  }

  // widget with button for adding steps , and display preview  with edition button
  Widget addTags() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.tags!.clear();
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
                  SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.tags!.clear();
                      });
                    },
                    child:
                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
                  ),
                ],
              )),
    ]);
  }

  // widget list view to show all tags and possibilty to edit, delete
  Widget showTagsAdded() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 242, 255, 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 400,
      child: ListView.builder(
        itemCount: widget.tags!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${widget.tags![index]}'),
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
                                text: widget.tags![index].toString()),
                          );
                        });
                    if (result != null) {
                      String data = result;
                      setState(() {});
                      widget.tags![index] = data;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      widget.tags!.removeAt(index);
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

  ////////// SHOW WIDGET WITH CONDITION : /////
  ///

  Widget ShowWidget() {
    setState(() {});
    if (isShowIngredientsSelectedPressed == false &&
        isshowStepsAddedPressed == false &&
        isshowTagsAddedPressed == false) {
      return Column(children: [
        addCategory(),
        addRecipeName(),
        addTotalTime(),
        addDifficulty(),
        addCost(),
        addPicture(),
        addIngred(),
        addSteps(),
        addTags(),
      ]);
    } else if (isShowIngredientsSelectedPressed == true) {
      return Column(children: [addIngred(), showIngredientsSelected()]);
    } else if (isshowStepsAddedPressed == true) {
      return Column(children: [
        addSteps(),
        showStepsAdded(),
      ]);
    } else if (isshowTagsAddedPressed == true) {
      return Column(children: [
        addTags(),
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
        title: Text(AppLocalizations.of(context)!.editRecipe),
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
                    final finalEditRecipeName = widget.editRecipeName ==
                            AppLocalizations.of(context)!.deleted
                        ? AppLocalizations.of(context)!.noTitle
                        : widget.editRecipeName;

                    final finalEditTotalTime = widget.editTotalTime ==
                            AppLocalizations.of(context)!.deleted
                        ? ""
                        : widget.editTotalTime;

                    final finalEditDifficulty = widget.editDifficulty ==
                            AppLocalizations.of(context)!.deleted
                        ? ""
                        : widget.editDifficulty;

                    final finalEditCost =
                        widget.editCost == AppLocalizations.of(context)!.deleted
                            ? ""
                            : widget.editCost;

                    // get all data
                    List recipeList = _myBox.get('ALL_LISTS') ?? [];

                    // get index of the list to edit

                    // Give edidted values to recipeList
                    recipeList[getIndex()][0] = finalEditRecipeName;
                    recipeList[getIndex()][1] = finalEditTotalTime;
                    recipeList[getIndex()][2] = finalEditDifficulty;
                    recipeList[getIndex()][3] = finalEditCost;
                    recipeList[getIndex()][4] = widget.editAllIngredient;
                    recipeList[getIndex()][5] = widget.editPathImage;
                    recipeList[getIndex()][6] = widget.editStepsRecipe;
                    recipeList[getIndex()][7] = widget.editRecipeCategory;
                    recipeList[getIndex()][14] = widget.editUrlImageScrap;

                    // Save edidted list in hive
                    _myBox.put("ALL_LISTS", recipeList);

                    // Create an instance of RecipeDetailsPage with the form data
                    RecipeStruct recipeDetailsPage = RecipeStruct(
                        recipeName: finalEditRecipeName,
                        totalTime: finalEditTotalTime,
                        difficulty: finalEditDifficulty,
                        cost: finalEditCost,
                        allIngredientSelected: widget.editAllIngredient,
                        pathImageSelectedFromImagePicker: widget.editPathImage,
                        stepsRecipeFromCreateSteps: widget.editStepsRecipe,
                        isFromScrap: recipeList[getIndex()][8],
                        tags: recipeList[getIndex()][10],
                        uniqueId: recipeList[getIndex()][9],
                        recipeCategory: recipeList[getIndex()][7],
                        isFromFilteredNameRecipe: false,
                        urlImageScrap: recipeList[getIndex()][14],
                        sourceUrlScrap: recipeList[getIndex()][15]);

                    //Navigate to the new page with the form data and save
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => recipeDetailsPage),
                    );

                    //Navigator.pop(context,
                    //  finalEditRecipeName); // in fact we could send antoher variable, it's to force filtered_name_recipe and recip_struct (after editing) to rebuild again and take in count the new recipe name
                  },
                  child: Text(AppLocalizations.of(context)!.saveChanges),
                ),
              )
            ],
          ]),
        ),
      ),
    );
  }
}
