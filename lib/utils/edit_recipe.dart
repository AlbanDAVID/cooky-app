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
import 'package:cook_app/utils/add_totaltime.dart';
import 'package:cook_app/utils/create_steps.dart';

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
  int index;

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
      required this.index})
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
        "Category:",
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
      widget.editRecipeName = recipeName;
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
        Text(widget.editRecipeName,
            style: widget.editRecipeName == "Deleted"
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
                  widget.editRecipeName = "Deleted";
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
        "Total time:",
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
        "Difficulty:",
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
                  widget.editDifficulty = "Deleted";
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
        "Cost:",
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
                  widget.editCost = "Deleted";
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

  // function to display a dialog with picture preview
  void _showImagePreview(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.file(
              File(widget.editPathImage!),
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
      widget.editPathImage = imageSelected;
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
              onTap: () {
                setState(() {
                  widget.editPathImage = "";
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
      print('Received data from SecondScreen: $allIngredientSelected');
      setState(() {});
      widget.editAllIngredient.addAll(allIngredientSelected);
    }
  }

  // widget with button for adding ingredients , and display preview  with edition button
  Widget addIngred() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                widget.editAllIngredient = [];
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

  // widget list view to show all selected ingredient and possibilty to edit, delete
  Widget showIngredientsSelected() {
    return Expanded(
        child: ListView.builder(
      itemCount: widget.editAllIngredient.length,
      itemBuilder: (context, index) {
        final ingredient = widget.editAllIngredient[index][0];
        final quantity = widget.editAllIngredient[index][1];
        final unit = widget.editAllIngredient[index][2];

        final formattedString = '$ingredient : ($quantity$unit)';
        return ListTile(
          title: Text(formattedString),
          trailing: Wrap(
            spacing: -16,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  widget.editAllIngredient.removeAt(index);
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
                    widget.editAllIngredient.removeAt(index);
                  });
                },
              ),
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
            onTap: () {
              setState(() {
                widget.editStepsRecipe = [];
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

  // widget list view to show all steps and possibilty to edit, delete
  Widget showStepsAdded() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.editStepsRecipe.length,
        itemBuilder: (context, index) {
          return ListTile(
            title:
                Text(' Step ${index + 1}:\n${widget.editStepsRecipe[index]}'),
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
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.editStepsRecipe.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  ////////////////////////////////////////////////////////
  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RECIPE CATEGORY :
              addCategory(),

              // RECIPE NAME :
              addRecipeName(),

              // TOTAL TIME :
              addTotalTime(),

              // DIFFICULTY :
              addDifficulty(),

              // COST:
              addCost(),

              // ADD PICTURE

              addPicture(),

              // SELECT INGREDIENT
              addIngred(),

              // SHOW INGREDIENTS SELECTED
              showIngredientsSelected(),
              // ADD STEPS
              addSteps(),

              // SHOW STEPS ADDED
              showStepsAdded(),

              // Button fot submit form
              ElevatedButton(
                onPressed: () {
                  // handle deleted variable
                  final finalEditRecipeName = widget.editRecipeName == "Deleted"
                      ? "No title"
                      : widget.editRecipeName;

                  final finalEditTotalTime = widget.editTotalTime == "Deleted"
                      ? ""
                      : widget.editTotalTime;

                  final finalEditDifficulty = widget.editDifficulty == "Deleted"
                      ? ""
                      : widget.editDifficulty;

                  final finalEditCost =
                      widget.editCost == "Deleted" ? "" : widget.editCost;

                  // get all data
                  List recipeList = _myBox.get('ALL_LISTS') ?? [];

                  // Give edidted values to recipeList
                  recipeList[widget.index][0] = finalEditRecipeName;
                  recipeList[widget.index][1] = finalEditTotalTime;
                  recipeList[widget.index][2] = finalEditDifficulty;
                  recipeList[widget.index][3] = finalEditCost;
                  recipeList[widget.index][4] = widget.editAllIngredient;
                  recipeList[widget.index][5] = widget.editPathImage;
                  recipeList[widget.index][6] = widget.editStepsRecipe;
                  recipeList[widget.index][7] = widget.editRecipeCategory;

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
                  );

                  // Navigate to the new page with the form data and save
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => recipeDetailsPage),
                  );
                },
                child: Text("Save changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
