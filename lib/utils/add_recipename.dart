// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cook_app/data/categories_database/categories_names.dart';
import 'package:cook_app/data/categories_database/categories_names_services.dart';
import 'package:cook_app/pages/filtered_name_recipe.dart';
import 'package:cook_app/utils/create_recipe.dart';
import 'package:cook_app/utils/search_bar_UI.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddRecipeName extends StatefulWidget {
  const AddRecipeName({super.key});

  @override
  State<AddRecipeName> createState() => _AddRecipeNameState();
}

class _AddRecipeNameState extends State<AddRecipeName> {
  final TextEditingController _controller = TextEditingController();
  late List<String> recipeNameList;
  late List<String> filteredList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    recipeNameList = AppLocalizations.of(context)!.listCommonDishes.split(',');
    filteredList = recipeNameList;
  }

  // function to filter search
  void filterSearchResults(String query) {
    // get a list searchFiltred of the filtred search
    setState(() {
      filteredList = recipeNameList.where((item) {
        final itemLowerCase = item.toLowerCase(); // to lower case each items
        final input = query
            .toLowerCase(); // to lower case the input (what are typed by the user)
        return itemLowerCase
            .contains(input); // check the match between intem and input
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addRecipeName, maxLines: 2),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: [
            //IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
          SizedBox(
            height: 35,
          ),
          SearchBarUI(
            filterSearchResults: filterSearchResults,
            hintText: AppLocalizations.of(context)!.searchRecipeName,
          ),
          SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      Navigator.pop(context, filteredList[index]);
                    },
                    child: Center(
                      child: Text(
                        filteredList[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                },
              )),
          FloatingActionButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.addRecipeName,
                          textAlign: TextAlign.center),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.add),
                          onPressed: () async {
                            setState(() {
                              Navigator.pop(context);
                              recipeNameList.insert(0, _controller.text);
                            });
                          },
                        )
                      ],
                    );
                  });
            },
            child: Icon(Icons.add),
          ),
        ]));
  }
}
