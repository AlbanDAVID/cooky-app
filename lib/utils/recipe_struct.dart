// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:io';

import 'package:cook_app/pages/about.dart';
import 'package:cook_app/pages/filtered_name_recipe.dart';
import 'package:cook_app/pages/home.dart';
import 'package:cook_app/utils/add_pics.dart';
import 'package:cook_app/utils/edit_recipe.dart';
import 'package:cook_app/utils/steps_struct.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/recipe_database/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeStruct extends StatefulWidget {
  final String recipeName;
  final String totalTime;
  final String difficulty;
  final String cost;
  final List allIngredientSelected;
  final String? pathImageSelectedFromImagePicker;
  final List<String> stepsRecipeFromCreateSteps;
  final bool isFromScrap;
  List?
      tags; // not final and not required because I added after, so olders recipes does not have tags in their index. So, it can't works for old recipe if this fiels is required
  String uniqueId;
  String recipeCategory;

  RecipeStruct({
    super.key,
    required this.recipeName,
    required this.totalTime,
    required this.difficulty,
    required this.cost,
    required this.allIngredientSelected,
    required this.pathImageSelectedFromImagePicker,
    required this.stepsRecipeFromCreateSteps,
    required this.isFromScrap,
    this.tags,
    required this.uniqueId,
    required this.recipeCategory,
  });

  @override
  State<RecipeStruct> createState() => _RecipeStructState();
}

class _RecipeStructState extends State<RecipeStruct> {
  bool isShowIngredientPressed = false;
  late List<bool> _isChecked;
  String defautImage = "recipe_pics/no_image.png";
  List allTags = [];
  final ScrollController _scrollController = ScrollController();
  bool showArrow = true;

  // load database
  final _myBox = Hive.box('mybox');
  // initiate databse instance :
  RecipeDatabase db = RecipeDatabase();

  late final String finalEditRecipeName;

  @override
  void initState() {
    super.initState();
    // fir check ingredient box
    _isChecked = List<bool>.filled(widget.allIngredientSelected.length, false);

    // init of tags list
    if (widget.tags != null) {
      allTags.addAll(widget.tags!);
    }

    // init scrollController :
    _scrollController.addListener(_onScroll);

    // Check if list is large enough to scroll and if it's the case, show arrow, else don't show arrow
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.position.maxScrollExtent == 0) {
        setState(() {
          showArrow = false;
        });
      }
    });
  }

  // manage visibility of the arrow
  void _onScroll() {
    if (_scrollController.offset > 0 && showArrow) {
      setState(() {
        showArrow = false;
      });
    } else if (_scrollController.offset <= 0 && !showArrow) {
      setState(() {
        showArrow = true;
      });
    }
  }

  // function to edit recipe
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
  ) async {
    await Navigator.push(
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
        ),
      ),
    );
  }

  // function to delete a recipe
  void deleteOneRecipe() {
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    for (int i = 0; i < recipeList.length; i++) {
      if (recipeList[i][9] == widget.uniqueId) {
        recipeList.removeAt(i);
      }
    }
    _myBox.put('ALL_LISTS', recipeList);
  }

  void _dialogDelete(
    BuildContext context,
  ) {
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
                      deleteOneRecipe();
                      // go back to the 1 last page (this page :  RecipeStruct)
                      Navigator.pop(context);
                      // go back to the 2 last page (FilteredNameRecipe)
                      Navigator.pop(context, "force rebuild page");
                    });
                  },
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context)!.confirmLongPress2,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red)),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.back),
                  ),
                ],
              ));
        });
  }

  // function for handle click on popup menu
  void handleClick(int item) {
    switch (item) {
      case 0: //edit
        setState(() {
          sendDataToEditAtEditRecipe(
            context,
            widget.allIngredientSelected,
            widget.stepsRecipeFromCreateSteps,
            widget.recipeCategory,
            widget.recipeName,
            widget.totalTime,
            widget.difficulty,
            widget.cost,
            widget.isFromScrap,
            widget.pathImageSelectedFromImagePicker,
            widget.tags,
            widget.uniqueId,
          );
        });

      case 1: // delete
        setState(() {
          _dialogDelete(context);
        });
    }
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
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) => handleClick(item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 0, child: Text(AppLocalizations.of(context)!.edit)),
                PopupMenuItem<int>(
                    value: 1, child: Text(AppLocalizations.of(context)!.delete))
              ],
            ),
          ],
          //leading: const Icon(Icons.menu),
        ),
        body: Column(children: [
          // alow to develop or collapse ingredients list :
          if (isShowIngredientPressed == true) ...[
            TextButton(
                onPressed: () {
                  setState(() {
                    isShowIngredientPressed = false;
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
                              ('${widget.totalTime}  '),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Difficulty
                            Text(
                              ('${widget.difficulty}  '),
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
                        SizedBox(height: 16),
                        // tags
                        if (widget.tags != null) ...[
                          Row(children: [
                            Expanded(
                                child: SizedBox(
                                    height: 100,
                                    child: ListView.separated(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: allTags.length,
                                      itemBuilder: (context, index) {
                                        return Chip(
                                            label: Text('${allTags[index]}'));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          width: 5,
                                        );
                                      },
                                    ))),
                            SizedBox(
                              width: 0,
                            ),
                            if (showArrow)
                              IconButton(
                                  onPressed: () {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  icon: Icon(Icons.arrow_circle_right_sharp)),
                          ])
                        ],

                        if (widget.tags == null) ...[
                          Text("")
                        ], // show nothing if widget.tags == null

                        SizedBox(height: 30),
                        // Show ingrdient button
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isShowIngredientPressed = true;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.showIngred,
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
                    label: Text(AppLocalizations.of(context)!.startToCook),
                  ),
                ))
          ],
        ]));
  }
}
