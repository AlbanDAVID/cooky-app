// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
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
  late TextEditingController _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    recipeNameList = AppLocalizations.of(context)!.listCommonDishes.split(',');
    filteredList = recipeNameList;
    _searchController = TextEditingController();
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
          TextField(
              controller: _searchController,
              onChanged: (value) {
                filterSearchResults(value);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          filterSearchResults('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                hintText: AppLocalizations.of(context)!.searchRecipeName,
              )),
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
              _searchController.clear();
              filterSearchResults('');
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                              ),
                              onPressed: () async {
                                // go back to 1 last page
                                Navigator.pop(context);
                                _controller.clear();
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              child: Text(
                                AppLocalizations.of(context)!.add,
                              ),
                              onPressed: () async {
                                // go back to 1 last page
                                Navigator.pop(context);
                                // go back to 2 last page (create recipe) and send data
                                Navigator.pop(context, _controller.text);
                              },
                            )
                          ],
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
