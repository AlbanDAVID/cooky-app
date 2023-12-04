// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cook_app/utils/add_pics.dart';
import 'package:cook_app/utils/steps_struct.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/recipe_database/database.dart';

class RecipeStruct extends StatefulWidget {
  final String recipeName;
  final String totalTime;
  final String difficulty;
  final String cost;
  final List allIngredientSelected;
  final String? pathImageSelectedFromImagePicker;
  final List<String> stepsRecipeFromCreateSteps;
  final bool isFromScrap;

  const RecipeStruct({
    super.key,
    required this.recipeName,
    required this.totalTime,
    required this.difficulty,
    required this.cost,
    required this.allIngredientSelected,
    required this.pathImageSelectedFromImagePicker,
    required this.stepsRecipeFromCreateSteps,
    required this.isFromScrap,
  });

  @override
  State<RecipeStruct> createState() => _RecipeStructState();
}

class _RecipeStructState extends State<RecipeStruct> {
  bool isShowIngredientPressed = false;
  late List<bool> _isChecked;
  String defautImage = "recipe_pics/no_image.png";

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(widget.allIngredientSelected.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Title (recipe name)

          title: Text(
            maxLines: 2,
            widget.recipeName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
        ),
        body: Column(children: [
          if (isShowIngredientPressed == true) ...[
            TextButton(
                onPressed: () {
                  setState(() {
                    isShowIngredientPressed = false;
                  });
                },
                child: Row(
                  children: const [
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
                )),
            SizedBox(
                height: 600,
                child: ListView.builder(
                  itemCount: widget.allIngredientSelected.length,
                  itemBuilder: (context, index) {
                    final ingredient = widget.allIngredientSelected[index][0];
                    final quantity = widget.allIngredientSelected[index][1];
                    final unit = widget.allIngredientSelected[index][2];

                    final formattedString = '$ingredient : ($quantity$unit)';
                    return widget.isFromScrap
                        ? ListTile(
                            title: Text(widget.allIngredientSelected[index]),
                            trailing: Checkbox(
                                value: _isChecked[index],
                                onChanged: (bool? value) {
                                  if (_isChecked[index] == false) {
                                    return setState(() {
                                      _isChecked[index] = true;
                                    });
                                  } else {
                                    return setState(() {
                                      _isChecked[index] = false;
                                    });
                                  }
                                }),
                          )
                        : ListTile(
                            title: Text(formattedString),
                            trailing: Checkbox(
                              value: _isChecked[index],
                              onChanged: (bool? value) {
                                if (_isChecked[index] == false) {
                                  return setState(() {
                                    _isChecked[index] = true;
                                  });
                                } else {
                                  return setState(() {
                                    _isChecked[index] = false;
                                  });
                                }
                              },
                            ),
                          );
                  },
                ))
          ],
          if (isShowIngredientPressed == false) ...[
            Expanded(
                child: ListView(children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                          child: Column(children: [
                        // Spacing between title and image
                        SizedBox(height: 16),

                        // Recipe picture
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: widget.pathImageSelectedFromImagePicker !=
                                    null
                                ? Image.file(
                                    File(widget
                                        .pathImageSelectedFromImagePicker!),
                                  ) // File(imageSelectedFromImagePicker!) to transform string path to a widget (ClipRRect does not support Imge.file with just string path, need a widget)
                                : Image.asset(
                                    defautImage,
                                  ),
                          ),
                        ),

                        // Spacing between title and image
                        SizedBox(height: 16),

                        // Row for info (time, difficulty, cost)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Total time
                            Text(
                              ('${widget.totalTime} ~ '),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Difficulty
                            Text(
                              ('${widget.difficulty} ~ '),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Cost
                            Text(
                              widget.cost,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 30),
                        // Ingrédients (TODO : add checkbox)
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isShowIngredientPressed = true;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Show ingredients",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_upward,
                                  size:
                                      16, // ajustez la taille selon vos besoins
                                ),
                              ],
                            )),
                      ]))))
            ])),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowRecipeSteps(
                                  steps: widget.stepsRecipeFromCreateSteps,
                                )),
                      );
                    },
                    label: Text("Start to cook!"),
                  ),
                ))
          ],
        ]));
  }
}
