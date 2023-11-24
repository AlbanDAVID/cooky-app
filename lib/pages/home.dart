// ignore_for_file: prefer_const_constructors

import 'package:cook_app/pages/filtered_name_recipe.dart';
import 'package:cook_app/utils/edit_recipe.dart';
import 'package:cook_app/utils/recipe_struct.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _myBox = Hive.box('mybox');
  final _myBox2 = Hive.box('mybox2');
  RecipeDatabase db = RecipeDatabase();
  //CategoryRecipeDatabase db2 = CategoryRecipeDatabase();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for Hive initialization to complete
      await Hive.initFlutter();
      await Hive.openBox('mybox');
      await Hive.openBox('mybox2');

      // Load data after initialization is complete
      // load data from RecipeDatabase :
      db.loadData();
      //db.loadDataCategoryRecipeDatabase();
      // load data from CategoryRecipeDatabase
      //db2.loadDataCategoryRecipeDatabase();
    });
  }

  loadAllData() {
    // load data from RecipeDatabase :
    db.loadData();
    //db.loadDataCategoryRecipeDatabase();
    // load data from CategoryRecipeDatabase

    setState(() {}); // Calling setState to force the widget to be rebuilt
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COOKY"),
        centerTitle: true,
        elevation: 0,
        //leading: const Icon(Icons.menu),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      // COMMENT BELLOW FOR TESTING CAMERA AND GALERIE
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              loadAllData();
              RecipeStruct recipeInstance = RecipeStruct(
                recipeName: db.recipeList[0][0],
                totalTime: db.recipeList[0][1],
                difficulty: db.recipeList[0][2],
                cost: db.recipeList[0][3],
                allIngredientSelected: db.recipeList[0][4],
                pathImageSelectedFromImagePicker: db.recipeList[0][5],
                stepsRecipeFromCreateSteps: db.recipeList[0][6],
              );

              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => recipeInstance,
                ),
              );
            },
            child: Text('Go to Recipe 1'),
            onLongPress: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRecipe(),
                ),
              );
              if (result != null) {
                String recipeNameEdited = result;
                print('Received data from SecondScreen: $recipeNameEdited');
                setState(() {});
                db.recipeList[0][0] = recipeNameEdited;
                db.updateDataBase();
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              loadAllData();
              RecipeStruct recipeInstance = RecipeStruct(
                recipeName: db.recipeList[1][0],
                totalTime: db.recipeList[1][1],
                difficulty: db.recipeList[1][2],
                cost: db.recipeList[1][3],
                allIngredientSelected: db.recipeList[1][4],
                pathImageSelectedFromImagePicker: db.recipeList[1][5],
                stepsRecipeFromCreateSteps: db.recipeList[1][6],
              );

              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => recipeInstance,
                ),
              );
            },
            child: Text('Go to Recipe 2'),
          ),
          ElevatedButton(
            onPressed: () {
              loadAllData();
              RecipeStruct recipeInstance = RecipeStruct(
                recipeName: db.recipeList[2][0],
                totalTime: db.recipeList[2][1],
                difficulty: db.recipeList[2][2],
                cost: db.recipeList[2][3],
                allIngredientSelected: db.recipeList[2][4],
                pathImageSelectedFromImagePicker: db.recipeList[2][5],
                stepsRecipeFromCreateSteps: db.recipeList[2][6],
              );

              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => recipeInstance,
                ),
              );
            },
            child: Text('Go to Recipe 3'),
          ),
          FutureBuilder(
            // Need to wait loaAllData() before ListView.builder executed
            future: loadAllData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Shows a loading indicator if the function is running
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Show an error message if loadAllData() fails
                return Text('Erreur: ${snapshot.error}');
              } else {
                // Once loadAllData() is complete, constructs the ListView.builder
                return Expanded(
                    child: ListView.builder(
                  itemCount: db.categoryRecipeList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(db.categoryRecipeList[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilteredNameRecipe(
                              categoryName:
                                  db.categoryRecipeList[index].toString(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ));
              }
            },
          ),
        ],
      )),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 113, 153, 187),
        child: Column(children: [
          DrawerHeader(
              child: Icon(
            Icons.cookie,
            size: 48,
          )),
          // home page list tile
          // ignore: prefer_const_constructors
          ListTile(
            leading: Icon(Icons.home),
            title: Text("H O M E"),
          ),
          ListTile(
            leading: Icon(Icons.dining),
            title: Text("R E C I P E S"),
            onTap: () {
              Navigator.pushNamed(context, '/recipe');
            },
          ),
          ListTile(
            leading: Icon(Icons.trending_up),
            title: Text("S T A T S"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("S E T T I N G S"),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create_recipe');
        },
        label: const Text("Add delightful recipe"),
      ),
    );
  }
}
