// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cook_app/pages/filtered_name_recipe.dart';
import 'package:cook_app/utils/categories_names.dart';
import 'package:cook_app/utils/categories_names_services.dart';
import 'package:cook_app/utils/categories_names_services.dart';
import 'package:cook_app/utils/edit_recipe.dart';
import 'package:cook_app/utils/recipe_struct.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cook_app/data/database.dart';

import '../utils/categories_names_services.dart';

class Home extends StatefulWidget {
  Home({super.key});

  // Create a instance of CategoriesNames :

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _myBox = Hive.box('mybox');
  final List categories = [
    "Starter",
    "Main",
    "Side Dishes",
    "Dessert",
    "Snacks",
    "Breakfast",
    "Brunch",
    "Drinks",
  ];

  RecipeDatabase db = RecipeDatabase();

  final CategoriesNamesService _categoriesNamesService =
      CategoriesNamesService();
  final TextEditingController _controller = TextEditingController();
  final String _boxName = "catBox";
  @override
  void initState() {
    super.initState();
//    // WidgetsBinding.instance.addPostFrameCallback((_) async {
//    // Wait for Hive initialization to complete
//
//    //});
//
//    // await Hive.initFlutter();
//    // await Hive.openBox('mybox');
//
//    // load data from RecipeDatabase :
//    //db.loadData();
    initDatabase();
  }

//
//  // Method to initialize the database
  Future<void> initDatabase() async {
//    // Wait for Hive initialization to complete
    await Hive.initFlutter();
    //await Hive.openBox("catBox");
//    //await Hive.openBox('mybox');
//
//    //db.loadData();
//    // Load data from RecipeDatabase
    await _categoriesNamesService.getAllCategories();
//
//    // Optional: Load other data or perform additional initialization
  }
//
//  loadAllData() {
//    // load data from RecipeDatabase :
//    db.loadData();
//    setState(() {}); // Calling setState to force the widget to be rebuilt
//  }

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
      body: Column(children: [
        Expanded(
            child: ValueListenableBuilder(
          valueListenable: Hive.box<CategoriesNames>('catBox').listenable(),
          builder: (context, Box<CategoriesNames> box, _) {
            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                var cat = box.getAt(index);
                return ListTile(
                  title: Text(cat!.categoryName),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _categoriesNamesService.deleteCategory(index);
                    },
                  ),
                );
              },
            );
          },
        )),
        FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Add category'),
                    content: TextField(
                      controller: _controller,
                    ),
                    actions: [
                      ElevatedButton(
                        child: Text('Add'),
                        onPressed: () async {
                          var catName = CategoriesNames(_controller.text);
                          await _categoriesNamesService.addCategory(catName);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          },
          child: Icon(Icons.add),
        ),

        //     Expanded(
        //         child: ListView.builder(
        //       itemCount: categories.length,
        //       itemBuilder: (context, index) {
        //         return Padding(
        //             padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
        //             child: TextButton(
        //               onPressed: () {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => FilteredNameRecipe(
        //                       categoryName: categories[index].toString(),
        //                     ),
        //                   ),
        //                 );
        //               },
        //               style: TextButton.styleFrom(
        //                 backgroundColor: Colors.lightGreen, // Couleur du bouton
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius:
        //                       BorderRadius.circular(20.0), // Bords arrondis
        //                 ),
        //               ),
        //               child: Center(
        //                 child: Text(
        //                   categories[index],
        //                   style: TextStyle(fontSize: 25.0, color: Colors.white),
        //                 ),
        //               ),
        //             ));
        //       },
        //     )),
        // dial box for add categorie

        // For create dynamic CRUD categories list..
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
      ]),
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

      // open a dialbox to add cotegory:

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create_recipe');
        },
        label: const Text("Add delightful recipe"),
      ),
    );
  }
}

// create stateless widget for get all data from CategoriesNamesService
class GetAllCategoriesNames extends StatefulWidget {
  const GetAllCategoriesNames({super.key});

  @override
  State<GetAllCategoriesNames> createState() => _GetAllCategoriesNamesState();
}

class _GetAllCategoriesNamesState extends State<GetAllCategoriesNames> {
  final CategoriesNamesService _categoriesNamesService =
      CategoriesNamesService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _categoriesNamesService.getAllCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoriesNames>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
