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
  final List categories = ["Starter", "Main", "Dessert"];

  RecipeDatabase db = RecipeDatabase();
  //CategoryRecipeDatabase db2 = CategoryRecipeDatabase();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for Hive initialization to complete
      await Hive.initFlutter();
      // await Hive.openBox('mybox');
      await Hive.openBox('mybox');

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
          Expanded(
              child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categories[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilteredNameRecipe(
                        categoryName: categories[index].toString(),
                      ),
                    ),
                  );
                },
              );
            },
          ))
          // FutureBuilder(
          //   // Need to wait loaAllData() before ListView.builder executed
          //   future: loadAllData(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       // Shows a loading indicator if the function is running
          //       return CircularProgressIndicator();
          //     } else if (snapshot.hasError) {
          //       // Show an error message if loadAllData() fails
          //       return Text('Erreur: ${snapshot.error}');
          //     } else {
          //       // Once loadAllData() is complete, constructs the ListView.builder
          //       return Expanded(
          //           child: ListView.builder(
          //         itemCount: db.recipeList[8],
          //         itemBuilder: (context, index) {
          //           return ListTile(
          //             title: Text(db.recipeList[index][8]),
          //             onTap: () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => FilteredNameRecipe(
          //                     categoryName: db.recipeList[index].toString(),
          //                   ),
          //                 ),
          //               );
          //             },
          //           );
          //         },
          //       ));
          //     }
          //   },
          // ),
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
