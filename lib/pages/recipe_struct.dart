// ignore_for_file: prefer_const_constructors, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:Cooky/pages/home.dart';
import 'package:Cooky/pages/edit_recipe.dart';
import 'package:Cooky/utils/steps_struct.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Cooky/data/recipe_database/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isFromFilteredNameRecipe;
  final String? urlImageScrap;
  final String? sourceUrlScrap;

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
    required this.isFromFilteredNameRecipe,
    this.urlImageScrap,
    this.sourceUrlScrap,
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

  // manage visibility of the arrow (for tags list view horizontal scroll)
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

  // function to decide image to display
  _imageToDisplay() {
    if (widget.urlImageScrap != null) {
      return Image.network(
        widget.urlImageScrap!,
      );
    } else if (widget.pathImageSelectedFromImagePicker != null) {
      return Image.file(
        File(widget.pathImageSelectedFromImagePicker!),
      );
    } else if (widget.urlImageScrap == null &&
        widget.pathImageSelectedFromImagePicker == null) {
      return Image.asset(
        defautImage,
      );
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
      editUrlScrap) async {
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
          editUrlImageScrap: editUrlScrap,
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
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

  // function to lauch an url
  _launchURL(url) async {
    Uri _url = Uri.parse(url);
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  // dial box to display source url scrap
  void _dialogUrlScrap(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, 200, 0, 100),
              child: AlertDialog(
                content: TextButton(
                  onPressed: () {
                    _launchURL(widget.sourceUrlScrap);
                  },
                  child: Text(
                    widget.sourceUrlScrap!,
                    textAlign: TextAlign.center,
                  ),
                ),

                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.back),
                  ),
                ],
                // Ajustez les valeurs selon vos besoins
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
              widget.urlImageScrap);
        });

      case 1: // delete
        setState(() {
          _dialogDelete(context);
        });

      case 2: // urls scrap source
        setState(() {
          _dialogUrlScrap(context);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: widget.isFromFilteredNameRecipe ? true : false,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 100.0,
              // Title (recipe name)
              title: Text(
                textAlign: TextAlign.center,
                maxLines: 3,
                widget.recipeName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              centerTitle: true,
              elevation: 0,
              leading: widget.isFromFilteredNameRecipe
                  ? IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    )
                  : IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      icon: Icon(Icons.home),
                    ),

              actions: [
                PopupMenuButton<int>(
                  onSelected: (item) => handleClick(item),
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                        value: 0,
                        child: Text(AppLocalizations.of(context)!.edit)),
                    PopupMenuItem<int>(
                        value: 1,
                        child: Text(AppLocalizations.of(context)!.delete)),
                    if (widget.sourceUrlScrap != null)
                      PopupMenuItem<int>(
                          value: 2,
                          child: Text(
                              AppLocalizations.of(context)!.sourceUrlScrap)),
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
                        final ingredient =
                            widget.allIngredientSelected[index][0];
                        final quantity = widget.allIngredientSelected[index][1];
                        final unit = widget.allIngredientSelected[index][2];

                        final formattedString =
                            '$ingredient : ($quantity$unit)';
                        return widget.isFromScrap
                            ? ListTile(
                                title:
                                    Text(widget.allIngredientSelected[index]),
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
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                          child: Column(children: [
                        // Spacing between title and image

                        // Recipe picture
                        Container(
                            height: 400,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: _imageToDisplay(),
                              ),
                            )),

                        // Spacing between title and image
                        SizedBox(height: 16),

                        // Row for info (time, difficulty, cost)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Total time
                            Row(children: [
                              if (widget.totalTime != "")
                                Icon(Icons.access_time),
                              Text(
                                (' ${widget.totalTime} '),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]),
                            // Difficulty
                            if (widget.difficulty != "")
                              Row(children: [
                                Icon(Icons.cookie_outlined),
                                Text(
                                  (' ${widget.difficulty} '),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                            // Cost
                            if (widget.cost != "")
                              Row(children: [
                                Icon(Icons.monetization_on_outlined),
                                Text(
                                  (' ${widget.cost} '),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                          ],
                        ),
                        SizedBox(height: 16),
                        // tags
                        if (widget.tags != null) ...[
                          Row(children: [
                            Expanded(
                                child: SizedBox(
                                    height: 70,
                                    child: ListView.separated(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: allTags.length,
                                      itemBuilder: (context, index) {
                                        return Chip(
                                            padding: EdgeInsets.all(0),
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
                      ])))
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
            ])));
  }
}
