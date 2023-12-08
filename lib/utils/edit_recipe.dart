// ignore_for_file: prefer_const_constructors

import 'dart:ffi';
import 'dart:io';

import 'package:cook_app/data/recipe_database/database.dart';
import 'package:cook_app/utils/add_category.dart';
import 'package:cook_app/utils/add_cost.dart';
import 'package:cook_app/utils/add_difficulty.dart';
import 'package:cook_app/utils/add_ingredients.dart';
import 'package:cook_app/utils/add_pics.dart';
import 'package:cook_app/utils/add_recipename.dart';
import 'package:cook_app/utils/add_tags.dart';
import 'package:cook_app/utils/add_totaltime.dart';
import 'package:cook_app/utils/create_steps.dart';
import 'package:cook_app/utils/dialbox_edit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:cook_app/utils/recipe_struct.dart';
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

  EditRecipe(
      {Key? key,
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
      required this.uniqueId})
      : super(key: key);

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

      print('Received data from SecondScreen: $categoryName');
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
            fontSize: 20,
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

      print('Received data from SecondScreen: $recipeName');
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
            width: 300,
            child: Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              widget.editRecipeName,
              style: widget.editRecipeName == "Deleted"
                  ? TextStyle(fontSize: 15, fontStyle: FontStyle.italic)
                  : TextStyle(
                      fontSize: 20,
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
                  print('Received data from SecondScreen: $data');
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
                  widget.editRecipeName = "Deleted";
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

      print('Received data from SecondScreen: $totalTime');
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
            style: widget.editTotalTime == "Deleted"
                ? TextStyle(fontSize: 15, fontStyle: FontStyle.italic)
                : TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  print('Received data from SecondScreen: $data');
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
                  widget.editTotalTime = "Deleted";
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

      print('Received data from SecondScreen: $difficulty');
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
            style: widget.editDifficulty == "Deleted"
                ? TextStyle(fontSize: 15, fontStyle: FontStyle.italic)
                : TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  print('Received data from SecondScreen: $data');
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
                  widget.editDifficulty = "Deleted";
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

      print('Received data from SecondScreen: $cost');
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
            style: widget.editCost == "Deleted"
                ? TextStyle(fontSize: 15, fontStyle: FontStyle.italic)
                : TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  print('Received data from SecondScreen: $data');
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
                  widget.editCost = "Deleted";
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

  // function to display a dialog with picture preview
  void _showImagePreview(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: widget.editPathImage != null
                ? Image.file(
                    File(widget.editPathImage!),
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
      print('Received data from SecondScreen: $imageSelected');
      setState(() {});

      widget.editPathImage = imageSelected;
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
                fontSize: 20,
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
      print('Received data from SecondScreen: $allIngredientSelected');
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
                ],
              )),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
                      print(
                          'Received data from SecondScreen: $addedIngredScrap');
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
            child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
          ),
        ],
      )
    ]);
  }

  // widget list view to show all selected ingredient and possibilty to edit, delete
  Widget showIngredientsSelected() {
    return SizedBox(
        height: 600,
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
                              print(
                                  'Received data from SecondScreen: $addedIngredScrap');
                              setState(() {});
                              widget.editAllIngredient[index] =
                                  addedIngredScrap;
                            }
                          }
                        : () {
                            widget.editAllIngredient.removeAt(index);
                            getDataFromAddIngred(context);
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
      print('Received data from SecondScreen: $stepsRecipe');
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
                ],
              )),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
            child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
          ),
        ],
      )
    ]);
  }

  // widget list view to show all steps and possibilty to edit, delete
  Widget showStepsAdded() {
    return SizedBox(
      height: 600,
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
                      print('Received data from SecondScreen: $stepEdited');
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
      print('Received data from SecondScreen: $data');
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
                ],
              )),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
            child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
          ),
        ],
      )
    ]);
  }

  // widget list view to show all tags and possibilty to edit, delete
  Widget showTagsAdded() {
    return SizedBox(
      height: 600,
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
                      print('Received data from SecondScreen: $data');
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

  @override
  Widget build(BuildContext context) {
    // use WillPopScope for pop an alert dialog before exiting page. It works, but is deprecated
    return WillPopScope(
        onWillPop: () async {
          final value = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                      height: 300.0,
                      child: Column(children: [
                        Text(AppLocalizations.of(context)!.areYouSureExit,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Center(
                            child: Text(
                                AppLocalizations.of(context)!.saveEditLater,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, fontStyle: FontStyle.italic)))
                      ])),
                  actions: <Widget>[
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.confirmExit,
                          style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        Navigator.of(context).pop(true);
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

          return value == true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.editRecipe),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            final finalEditRecipeName =
                                widget.editRecipeName == "Deleted"
                                    ? "No title"
                                    : widget.editRecipeName;

                            final finalEditTotalTime =
                                widget.editTotalTime == "Deleted"
                                    ? ""
                                    : widget.editTotalTime;

                            final finalEditDifficulty =
                                widget.editDifficulty == "Deleted"
                                    ? ""
                                    : widget.editDifficulty;

                            final finalEditCost = widget.editCost == "Deleted"
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
                            recipeList[getIndex()][4] =
                                widget.editAllIngredient;
                            recipeList[getIndex()][5] = widget.editPathImage;
                            recipeList[getIndex()][6] = widget.editStepsRecipe;
                            recipeList[getIndex()][7] =
                                widget.editRecipeCategory;

                            // Save edidted list in hive
                            _myBox.put("ALL_LISTS", recipeList);

                            print(getIndex());

                            // Create an instance of RecipeDetailsPage with the form data
                            // RecipeStruct recipeDetailsPage = RecipeStruct(
                            //   recipeName: finalEditRecipeName,
                            //   totalTime: finalEditTotalTime,
                            //   difficulty: finalEditDifficulty,
                            //   cost: finalEditCost,
                            //   allIngredientSelected: widget.editAllIngredient,
                            //   pathImageSelectedFromImagePicker:
                            //       widget.editPathImage,
                            //   stepsRecipeFromCreateSteps: widget.editStepsRecipe,
                            //   isFromScrap: recipeList[widget.index][8],
                            // );

                            // Navigate to the new page with the form data and save
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => recipeDetailsPage),
                            //   );

                            Navigator.pop(context,
                                finalEditRecipeName); // in fact we could send antoher variable, it's to force filtered_name_recipe and recip_struct (after editing) to rebuild again and take in count the new recipe name
                          },
                          child:
                              Text(AppLocalizations.of(context)!.saveChanges),
                        ),
                      )
                    ],
                  ]),
            ),
          ),
        ));
  }
}
