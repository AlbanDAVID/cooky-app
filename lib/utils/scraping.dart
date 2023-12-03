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
import 'package:cook_app/utils/add_totaltime.dart';
import 'package:cook_app/utils/create_steps.dart';

import 'package:flutter/material.dart';
import 'package:cook_app/utils/recipe_struct.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class Scraping extends StatefulWidget {
  String scrapRecipeName;
  List scrapAllIngredient;
  List<String> scrapStepsRecipe;
  Scraping({
    Key? key,
    required this.scrapRecipeName,
    required this.scrapStepsRecipe,
    required this.scrapAllIngredient,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScrapingState createState() => _ScrapingState();
}

bool isShowIngredientsSelectedPressed = false;

class _ScrapingState extends State<Scraping> {
  // ignore: unused_field

  String? scrapPathImage;

  String scrapRecipeCategory = "From web";
  String scrapTotalTime = "";
  String scrapDifficulty = "";
  String scrapCost = "";
  bool isFromScrap = true;

  // load database
  final _myBox = Hive.box('mybox');
  // initiate databse instance :
  RecipeDatabase db = RecipeDatabase();

  String previewImageTextField = "";

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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Category:",
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
            size: 20,
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
        "Recipe name:",
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
              onTap: () {
                _getDataFromAddRecipeName(context);
              },
              child: Icon(
                Icons.create,
                size: 20,
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
      scrapTotalTime = totalTime;
    }
  }

  // widget with button for adding total time , and display time selected with edition button
  Widget addTotalTime() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Total time:",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(scrapTotalTime,
            style: scrapTotalTime == "Deleted"
                ? TextStyle(fontSize: 15, fontStyle: FontStyle.italic)
                : TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                _getDataFromAddTotalTime(context);
              },
              child: Icon(
                Icons.create,
                size: 20,
              ),
            ),
            SizedBox(width: 16), // Ajustez cet espace selon vos besoins
            InkWell(
              onLongPress: () {
                setState(() {
                  scrapTotalTime = "Deleted";
                  Text(
                    scrapTotalTime,
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
        "Difficulty:",
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
              onTap: () {
                _getDataFromAddDifficulty(context);
              },
              child: Icon(
                Icons.create,
                size: 20,
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
        "Cost:",
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
              onTap: () {
                _getDataFromAddCost(context);
              },
              child: Icon(
                Icons.create,
                size: 20,
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
            content: Image.file(
              File(scrapPathImage!),
              width: 200,
              height: 200,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
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
        "Picture : ",
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
              previewImageTextField = "Preview picture",
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
                size: 20,
              ),
            ),
            SizedBox(width: 16), // Ajustez cet espace selon vos besoins
            InkWell(
              onLongPress: () {
                setState(() {
                  scrapPathImage = "";
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
                    "Collapse",
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
                    "Show Ingredients",
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
                print('Received data from SecondScreen: $addedIngredScrap');
                setState(() {});
                widget.scrapAllIngredient.add(addedIngredScrap);
              }
            },
            child: Icon(
              Icons.add,
              size: 20,
            ),
          ),
          SizedBox(width: 16), // Ajustez cet espace selon vos besoins
          InkWell(
            onLongPress: () {
              setState(() {
                widget.scrapAllIngredient = [];
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
      Text(
        "Steps :",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              getDataFromCreateSteps(context);
            },
            child: Icon(
              Icons.add,
              size: 20,
            ),
          ),
          SizedBox(width: 16), // Ajustez cet espace selon vos besoins
          InkWell(
            onLongPress: () {
              setState(() {
                widget.scrapStepsRecipe = [];
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
    return Expanded(
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
  ///
  ///  ////////// SHOW WIDGET WITH CONDITION : /////
  ///

  Widget ShowWidget() {
    setState(() {});
    if (isShowIngredientsSelectedPressed == false) {
      return Column(children: [
        addCategory(),
        addRecipeName(),
        addTotalTime(),
        addDifficulty(),
        addCost(),
        addPicture(),
        addIngred(),
      ]);
    } else {
      return Column(children: [addIngred(), showIngredientsSelected()]);
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
                      height: 40.0,
                      child: Column(children: const [
                        Text('Are you sure you want to exit?',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Center(
                            child: Text('You can save changes and edit later',
                                style: TextStyle(
                                    fontSize: 15, fontStyle: FontStyle.italic)))
                      ])),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Yes, exit',
                          style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    TextButton(
                      child: Text('No',
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
            title: const Text('Edit Recipe'),
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
                  ElevatedButton(
                    onPressed: () {
                      // handle deleted variable
                      final finalscrapRecipeName =
                          widget.scrapRecipeName == "Deleted"
                              ? "No title"
                              : widget.scrapRecipeName;

                      final finalscrapTotalTime =
                          scrapTotalTime == "Deleted" ? "" : scrapTotalTime;

                      final finalscrapDifficulty =
                          scrapDifficulty == "Deleted" ? "" : scrapDifficulty;

                      final finalscrapCost =
                          scrapCost == "Deleted" ? "" : scrapCost;

                      // get all data
                      List listOfLists = _myBox.get('ALL_LISTS') ?? [];

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
                        isFromScrap
                      ]);

                      // Save edidted list in hive
                      _myBox.put("ALL_LISTS", listOfLists);

                      //Create an instance of RecipeDetailsPage with the form data
                      RecipeStruct recipeDetailsPage = RecipeStruct(
                        recipeName: finalscrapRecipeName,
                        totalTime: finalscrapTotalTime,
                        difficulty: finalscrapDifficulty,
                        cost: finalscrapCost,
                        allIngredientSelected: widget.scrapAllIngredient,
                        pathImageSelectedFromImagePicker: scrapPathImage,
                        stepsRecipeFromCreateSteps: widget.scrapStepsRecipe,
                        isFromScrap: isFromScrap,
                      );

                      // Navigate to the new page with the form data and save
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => recipeDetailsPage),
                      );
                    },
                    child: Text("Sumbit"),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
