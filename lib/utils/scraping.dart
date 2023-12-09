import 'dart:convert';

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
class Scraping extends StatefulWidget {
  String scrapRecipeName;
  List scrapAllIngredient;
  List<String> scrapStepsRecipe;
  String scrapTotalTime;
  List scrapTags;
  Scraping({
    super.key,
    required this.scrapRecipeName,
    required this.scrapStepsRecipe,
    required this.scrapAllIngredient,
    required this.scrapTotalTime,
    required this.scrapTags,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ScrapingState createState() => _ScrapingState();
}

class _ScrapingState extends State<Scraping> {
  // ignore: unused_field

  String? scrapPathImage;

  late String scrapRecipeCategory;

  String scrapDifficulty = "";
  String scrapCost = "";
  bool isFromScrap = true;

  bool isShowIngredientsSelectedPressed = false;
  bool isshowStepsAddedPressed = false;
  bool isButtonAddCategoryVisible = true;
  bool isshowTagsAddedPressed = false;

  // load database
  final _myBox = Hive.box('mybox');
  // initiate databse instance :
  RecipeDatabase db = RecipeDatabase();

  String previewImageTextField = "";
  String defautImage = "recipe_pics/no_image.png";

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
      scrapRecipeCategory = categoryName;
    }
  }

  // widget with button for adding category, and display category selected with edition button
  Widget addCategory() {
    setState(() {});
    return isButtonAddCategoryVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                isButtonAddCategoryVisible = false;
                _getDataFromAddExistingCategory(context);
              });
            },
            child: Text(AppLocalizations.of(context)!.addCategoryRequired),
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
                scrapRecipeCategory,
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
      widget.scrapRecipeName = recipeName;
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
            width: 300,
            child: Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              widget.scrapRecipeName,
              style: widget.scrapRecipeName == "Deleted"
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
                            TextEditingController(text: widget.scrapRecipeName),
                        isFromScrap: true,
                        showSuggestion: () {
                          _getDataFromAddRecipeName(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  print('Received data from SecondScreen: $data');
                  setState(() {});
                  widget.scrapRecipeName = data;
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
                  widget.scrapRecipeName = "Deleted";
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
      widget.scrapTotalTime = totalTime;
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
        Text(widget.scrapTotalTime,
            style: widget.scrapTotalTime == "Deleted"
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
                            TextEditingController(text: widget.scrapTotalTime),
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
                  widget.scrapTotalTime = data;
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
                  widget.scrapTotalTime = "Deleted";
                  Text(
                    widget.scrapTotalTime,
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
      scrapDifficulty = difficulty;
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
        Text(scrapDifficulty,
            style: scrapDifficulty == "Deleted"
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
                            TextEditingController(text: scrapDifficulty),
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
                  scrapDifficulty = data;
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
                  scrapDifficulty = "Deleted";
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
      scrapCost = cost;
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
        Text(scrapCost,
            style: scrapCost == "Deleted"
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
                        controller: TextEditingController(text: scrapCost),
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
                  scrapCost = data;
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
                  scrapCost = "Deleted";
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
            content: scrapPathImage != null
                ? Image.file(
                    File(scrapPathImage!),
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
      scrapPathImage = imageSelected;
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
                  scrapPathImage = null;
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
                    onTap: () async {
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
                        widget.scrapAllIngredient.add(addedIngredScrap);
                      }
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
                        widget.scrapAllIngredient = [];
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
                    onTap: () async {
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
                        widget.scrapAllIngredient.add(addedIngredScrap);
                      }
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
                        widget.scrapAllIngredient = [];
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
    return SizedBox(
        height: 600,
        child: ListView.builder(
          itemCount: widget.scrapAllIngredient.length,
          itemBuilder: (context, index) {
            //  final ingredient = scrapAllIngredient[index][0];
            //  final quantity = scrapAllIngredient[index][1];
            //  final unit = scrapAllIngredient[index][2];

            //  final formattedString = '$ingredient : ($quantity$unit)';
            return ListTile(
              title: Text(widget.scrapAllIngredient[index]),
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
                              text: widget.scrapAllIngredient[index].toString(),
                            ));
                          });
                      if (result != null) {
                        String addedIngredScrap = result;
                        print(
                            'Received data from SecondScreen: $addedIngredScrap');
                        setState(() {});
                        widget.scrapAllIngredient[index] = addedIngredScrap;
                      }
                    },
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        widget.scrapAllIngredient.removeAt(index);
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
      widget.scrapStepsRecipe.addAll(stepsRecipe);
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
                        widget.scrapStepsRecipe = [];
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
                        widget.scrapStepsRecipe = [];
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
    return SizedBox(
      height: 600,
      child: ListView.builder(
        itemCount: widget.scrapStepsRecipe.length,
        itemBuilder: (context, index) {
          return ListTile(
            title:
                Text(' Step ${index + 1}:\n${widget.scrapStepsRecipe[index]}'),
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
                                text:
                                    widget.scrapStepsRecipe[index].toString()),
                          );
                        });
                    if (result != null) {
                      String stepEdited = result;
                      print('Received data from SecondScreen: $stepEdited');
                      setState(() {});
                      widget.scrapStepsRecipe[index] = stepEdited;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      widget.scrapStepsRecipe.removeAt(index);
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
      widget.scrapTags!.addAll(data);
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
                        widget.scrapTags!.clear();
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
                        widget.scrapTags!.clear();
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
    return SizedBox(
      height: 600,
      child: ListView.builder(
        itemCount: widget.scrapTags!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${widget.scrapTags![index]}'),
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
                                text: widget.scrapTags![index].toString()),
                          );
                        });
                    if (result != null) {
                      String data = result;
                      print('Received data from SecondScreen: $data');
                      setState(() {});
                      widget.scrapTags![index] = data;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      widget.scrapTags!.removeAt(index);
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

  ///  ////////// SHOW WIDGET WITH CONDITION : /////
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
            title: Text(AppLocalizations.of(context)!.addFromWeb),
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
                              final finalscrapRecipeName =
                                  widget.scrapRecipeName == "Deleted"
                                      ? "No title"
                                      : widget.scrapRecipeName;

                              final finalscrapTotalTime =
                                  widget.scrapTotalTime == "Deleted"
                                      ? ""
                                      : widget.scrapTotalTime;

                              final finalscrapDifficulty =
                                  scrapDifficulty == "Deleted"
                                      ? ""
                                      : scrapDifficulty;

                              final finalscrapCost =
                                  scrapCost == "Deleted" ? "" : scrapCost;

                              // create a varible with the date of creation
                              DateTime now = DateTime.now();
                              String creationDate =
                                  'variable_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';

                              // get all data
                              List listOfLists = _myBox.get('ALL_LISTS') ?? [];

                              // create null index for future add :
                              double? stars = null;
                              List? detailTIme = null;
                              List? utensils = null;

                              // Give edidted values to recipeList
                              // Add a new list to the list of lists
                              listOfLists.add([
                                finalscrapRecipeName,
                                finalscrapTotalTime,
                                finalscrapDifficulty,
                                finalscrapCost,
                                widget.scrapAllIngredient,
                                scrapPathImage,
                                widget.scrapStepsRecipe,
                                scrapRecipeCategory,
                                isFromScrap,
                                creationDate,
                                widget.scrapTags,
                                stars,
                                detailTIme,
                                utensils,
                              ]);

                              // Save edidted list in hive
                              _myBox.put("ALL_LISTS", listOfLists);

                              //Create an instance of RecipeDetailsPage with the form data
                              RecipeStruct recipeDetailsPage = RecipeStruct(
                                recipeName: finalscrapRecipeName,
                                totalTime: finalscrapTotalTime,
                                difficulty: finalscrapDifficulty,
                                cost: finalscrapCost,
                                allIngredientSelected:
                                    widget.scrapAllIngredient,
                                pathImageSelectedFromImagePicker:
                                    scrapPathImage,
                                stepsRecipeFromCreateSteps:
                                    widget.scrapStepsRecipe,
                                isFromScrap: isFromScrap,
                                tags: widget.scrapTags,
                                uniqueId: creationDate,
                                recipeCategory: scrapRecipeCategory,
                                isFromFilteredNameRecipe: false,
                              );

                              // Navigate to the new page with the form data and save
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => recipeDetailsPage),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.add),
                          ))
                    ],
                  ]),
            ),
          ),
        ));
  }
}
