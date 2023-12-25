/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTags extends StatefulWidget {
  const AddTags({super.key});

  @override
  State<AddTags> createState() => _AddTagsState();
}

class _AddTagsState extends State<AddTags> {
  late List<String> tags; // listToFilter
  late List<String> filteredList = []; //filteredList

  final List selectedTags = []; // final list to submit
  final TextEditingController _controller = TextEditingController();
  late TextEditingController _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    tags = AppLocalizations.of(context)!.listTags.split(',');
    filteredList = tags;

    _searchController = TextEditingController();
  }

  // function to filter search
  void filterSearchResults(String query) {
    // get a list searchFiltred of the filtred search
    setState(() {
      filteredList = tags.where((item) {
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
    // add list from dialbox_add_ingredient to allIngredientSelected
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addTags),
          actions: [
            // IconButton(onPressed: () {showSearch(context: context, delegate: delegate)}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
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
                hintText: AppLocalizations.of(context)!.searchTag,
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50, top: 0),
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTags.insert(0, filteredList[index]);
                    });
                  },
                  child: Text(
                    filteredList[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ));
              },
            ),
          )),
          Expanded(
            child: ListView.builder(
              itemCount: selectedTags.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text('${selectedTags[index]}'),
                    trailing: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          selectedTags.removeAt(index);
                        });
                      },
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {},
                      ),
                    ));
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              _searchController.clear();
              filterSearchResults('');
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.addTag),
                        content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: AppLocalizations.of(context)!.writeTag,
                            )),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                child:
                                    Text(AppLocalizations.of(context)!.cancel),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              ElevatedButton(
                                child: Text(AppLocalizations.of(context)!.add),
                                onPressed: () async {
                                  selectedTags.add(
                                    _controller.text,
                                  );
                                  Navigator.pop(context);

                                  _controller.clear();

                                  filterSearchResults('');

                                  setState(() {});
                                },
                              )
                            ],
                          )
                        ]);
                  });
            },
            child: Icon(Icons.add),
          ),
          Container(
              padding: EdgeInsetsDirectional.all(20),
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedTags);
                },
                child: Text(AppLocalizations.of(context)!.add),
              ))
        ]));
  }
}
