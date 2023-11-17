// ignore_for_file: prefer_const_constructors

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
  final _myBox = Hive.box('mybox'); // pr charger la bdd sur home_page
  RecipeDatabase db = RecipeDatabase();
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Attendre que l'initialisation de Hive soit terminée
      await Hive.initFlutter();
      await Hive.openBox('mybox');

      // Charger les données après que l'initialisation est terminée
      db.loadData();
      // Appel de setState pour forcer la reconstruction du widget
    });
  }

  void loadAllData() {
    db.loadData();
    setState(
        () {}); // Appel de setState pour forcer la reconstruction du widget
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
                  allIngredientSelected: db.recipeList[0][4]);

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
                  allIngredientSelected: db.recipeList[1][4]);

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
                  allIngredientSelected: db.recipeList[2][4]);

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
