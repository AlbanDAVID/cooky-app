// ignore_for_file: prefer_const_constructors

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

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  // ignore: unused_field

  final TextEditingController ingredientController = TextEditingController();

  final _myBox = Hive.box('mybox'); // pr charger la bdd sur home_page
  RecipeDatabase db = RecipeDatabase();

  List<String> availableFields = ['Beurre', 'Farine', 'Oeuf(s)'];
  List<String> selectedFields = [];
  String? searchQuery;
  List allIngredientSelectedCreateRecipe = [];
  String? pathImageSelectedFromImagePicker;
  List<String> stepsRecipeFromCreateSteps = [];
  late String recipeCategoryFromAddExistingCategory;
  String recipeNameFromAddRecipeName = "No title";
  String totalTimeFromAddTotalTime = "";
  String varFromAddDifficulty = "";
  String varFromAddCost = "";
  String previewImageTextField = "";

  bool isButtonAddCategoryVisible = true;
  bool isButtonAddRecipeNameVisible = true;
  bool isButtonAddTotalTimeVisible = true;
  bool isButtonAddDifficultyVisible = true;
  bool isButtonAddCostVisible = true;
  bool isButtonAddPictureVisible = true;
  bool isButtonAddIngredVisible = true;

  ////// FUNCTIONS FOR RECIPE CATEGORY //////

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

        isButtonAddCategoryVisible = false;
      });
      recipeCategoryFromAddExistingCategory = categoryName;
    }
  }

  Widget addCategory(bool isButtonAddCategoryVisible) {
    setState(() {});
    return isButtonAddCategoryVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                isButtonAddCategoryVisible = false;
                _getDataFromAddExistingCategory(context);
              });
            },
            child: Text("Add category"),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Category:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                recipeCategoryFromAddExistingCategory,
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

        isButtonAddRecipeNameVisible = false;
      });
      recipeNameFromAddRecipeName = recipeName;
    }
  }

  Widget addRecipeName(bool isButtonAddRecipeNameVisible) {
    setState(() {});
    return isButtonAddRecipeNameVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                isButtonAddRecipeNameVisible = false;
                _getDataFromAddRecipeName(context);
              });
            },
            child: Text("Add recipe name"),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Recipe name:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(recipeNameFromAddRecipeName,
                  style: recipeNameFromAddRecipeName == "Deleted"
                      ? TextStyle(fontSize: 15, fontStyle: FontStyle.italic)
                      : TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    onTap: () {
                      setState(() {
                        recipeNameFromAddRecipeName = "Deleted";
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      size: 20,
                    ),
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

        isButtonAddTotalTimeVisible = false;
      });
      totalTimeFromAddTotalTime = totalTime;
    }
  }

  Widget addTotalTime(bool isButtonAddtotalTimeVisible) {
    setState(() {});
    return isButtonAddtotalTimeVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                isButtonAddTotalTimeVisible = false;
                _getDataFromAddTotalTime(context);
              });
            },
            child: Text("Add total time"),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Total time:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(totalTimeFromAddTotalTime,
                  style: totalTimeFromAddTotalTime == "Deleted"
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
                    onTap: () {
                      setState(() {
                        totalTimeFromAddTotalTime = "Deleted";
                        Text(
                          totalTimeFromAddTotalTime,
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      size: 20,
                    ),
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

        isButtonAddDifficultyVisible = false;
      });
      varFromAddDifficulty = difficulty;
    }
  }

  Widget addDifficulty(bool isButtonAddDifficulty) {
    setState(() {});
    return isButtonAddDifficulty
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                isButtonAddDifficultyVisible = false;
                _getDataFromAddDifficulty(context);
              });
            },
            child: Text("Add difficulty"),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Difficulty:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(varFromAddDifficulty,
                  style: varFromAddDifficulty == "Deleted"
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
                    onTap: () {
                      setState(() {
                        varFromAddDifficulty = "Deleted";
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      size: 20,
                    ),
                  ),
                ],
              )
            ]),
          ]);
  }

  ////////////////////////////////////////////////////////
  ///
  ////// //////////// FUNCTIONS FOR COST //////

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

        isButtonAddCostVisible = false;
      });
      varFromAddCost = cost;
    }
  }

  Widget addCost(bool isButtonAddCost) {
    setState(() {});
    return isButtonAddCost
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                isButtonAddCost = false;
                _getDataFromAddCost(context);
              });
            },
            child: Text("Add cost"),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Cost:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(varFromAddCost,
                  style: varFromAddCost == "Deleted"
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
                    onTap: () {
                      setState(() {
                        varFromAddCost = "Deleted";
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      size: 20,
                    ),
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

  void _showImagePreview(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.file(
              File(pathImageSelectedFromImagePicker!),
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
      setState(() {
        isButtonAddPictureVisible = false;
      });
      pathImageSelectedFromImagePicker = imageSelected;
    }
  }

  Widget addPicture(bool isButtonAddPictureVisible) {
    setState(() {});
    return isButtonAddPictureVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                isButtonAddPictureVisible = false;
                getDataFromMyImagePickerPage(context);
              });
            },
            child: Text("Add picture"),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    onTap: () {
                      setState(() {
                        pathImageSelectedFromImagePicker = "";
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      size: 20,
                    ),
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
      setState(() {
        isButtonAddIngredVisible = false;
      });
      allIngredientSelectedCreateRecipe.addAll(allIngredientSelected);
    }
  }

  Widget addIngred(bool isButtonAddIngredVisible) {
    setState(() {});
    return isButtonAddIngredVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                isButtonAddIngredVisible = false;
                getDataFromAddIngred(context);
              });
            },
            child: Text("Add ingredients"),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Ingredients :",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    getDataFromAddIngred(context);
                  },
                  child: Icon(
                    Icons.add,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16), // Ajustez cet espace selon vos besoins
                InkWell(
                  onTap: () {
                    setState(() {
                      allIngredientSelectedCreateRecipe = [];
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    size: 20,
                  ),
                ),
              ],
            )
          ]);
  }
  ////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RECIPE CATEGORY :
              addCategory(isButtonAddCategoryVisible),

              // RECIPE NAME :
              addRecipeName(isButtonAddRecipeNameVisible),

              // TOTAL TIME :
              addTotalTime(isButtonAddTotalTimeVisible),

              // DIFFICULTY :
              addDifficulty(isButtonAddDifficultyVisible),

              // COST:
              addCost(isButtonAddCostVisible),

              // ADD PICTURE

              addPicture(isButtonAddPictureVisible),

              // SELECT INGREDIENT
              addIngred(isButtonAddIngredVisible),

              // show ingreient selected
              Expanded(
                child: ListView.builder(
                  itemCount: allIngredientSelectedCreateRecipe.length,
                  itemBuilder: (context, index) {
                    final ingredient =
                        allIngredientSelectedCreateRecipe[index][0];
                    final quantity =
                        allIngredientSelectedCreateRecipe[index][1];
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
                              allIngredientSelectedCreateRecipe.removeAt(index);
                              getDataFromAddIngred(context);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                allIngredientSelectedCreateRecipe
                                    .removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // add steps
              ElevatedButton(
                  onPressed: () async {
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
                      stepsRecipeFromCreateSteps.addAll(stepsRecipe);
                    }
                  },
                  child: Text("Add steps")),

              // show steps added
              Expanded(
                child: ListView.builder(
                  itemCount: stepsRecipeFromCreateSteps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(
                            ' Step ${index + 1}:\n${stepsRecipeFromCreateSteps[index]}'));
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  List listOfLists = _myBox.get('ALL_LISTS') ?? [];

                  // handle deleted variable
                  final finalRecipeNameFromAddRecipeName =
                      recipeNameFromAddRecipeName == "Deleted"
                          ? "No title"
                          : recipeNameFromAddRecipeName;

                  final finalTotalTimeFromAddTotalTime =
                      totalTimeFromAddTotalTime == "Deleted"
                          ? ""
                          : totalTimeFromAddTotalTime;

                  final finalVarFromAddDifficulty =
                      varFromAddDifficulty == "Deleted"
                          ? ""
                          : varFromAddDifficulty;

                  final finalVarFromAddCost =
                      varFromAddCost == "Deleted" ? "" : varFromAddCost;

                  // Add a new list to the list of lists
                  listOfLists.add([
                    finalRecipeNameFromAddRecipeName,
                    finalTotalTimeFromAddTotalTime,
                    finalVarFromAddDifficulty,
                    finalVarFromAddCost,
                    allIngredientSelectedCreateRecipe,
                    pathImageSelectedFromImagePicker,
                    stepsRecipeFromCreateSteps,
                    recipeCategoryFromAddExistingCategory,
                  ]);

                  // Update list of lists in Hive
                  _myBox.put('ALL_LISTS', listOfLists);

                  // Create an instance of RecipeDetailsPage with the form data
                  RecipeStruct recipeDetailsPage = RecipeStruct(
                    recipeName: finalRecipeNameFromAddRecipeName,
                    totalTime: finalTotalTimeFromAddTotalTime,
                    difficulty: finalVarFromAddDifficulty,
                    cost: finalVarFromAddCost,
                    allIngredientSelected: allIngredientSelectedCreateRecipe,
                    pathImageSelectedFromImagePicker:
                        pathImageSelectedFromImagePicker,
                    stepsRecipeFromCreateSteps: stepsRecipeFromCreateSteps,
                  );

                  // Navigate to the new page with the form data and save
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => recipeDetailsPage),
                  );
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
