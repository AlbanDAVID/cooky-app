/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// ignore_for_file: use_build_context_synchronously

import 'package:Cooky/data/categories_database/categories_names.dart';
import 'package:Cooky/data/categories_database/categories_names_services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddExistingCategory extends StatefulWidget {
  const AddExistingCategory({super.key});

  @override
  State<AddExistingCategory> createState() => _AddExistingCategoryState();
}

class _AddExistingCategoryState extends State<AddExistingCategory> {
  final CategoriesNamesService _categoriesNamesService =
      CategoriesNamesService();
  final TextEditingController _controller = TextEditingController();
  bool isAddAlterDialogPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addCategory),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: const [
            // IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
          //const Text("Suggestions : ", style: TextStyle(fontSize: 13)),
          SizedBox(
              height: 400,
              child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<CategoriesNames>('catBox').listenable(),
                builder: (context, Box<CategoriesNames> box, _) {
                  return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          var cat = box.getAt(index);
                          return TextButton(
                            onPressed: () {
                              final String categoryName =
                                  cat.categoryName.toString();
                              Navigator.pop(context, categoryName);
                            },
                            child: Center(
                              child: Text(
                                cat!.categoryName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          );
                        },
                      ));
                },
              )),
          FloatingActionButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.addCategory,
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
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                child: Text(
                                  AppLocalizations.of(context)!.add,
                                ),
                                onPressed: () async {
                                  if (_controller.text.trim().isNotEmpty) {
                                    var catName =
                                        CategoriesNames(_controller.text);
                                    await _categoriesNamesService
                                        .addCategory(catName);

                                    // go back to 1 last page
                                    Navigator.pop(context);
                                    // go back to 2 last page (create recipe) and send data
                                    Navigator.pop(context, _controller.text);
                                  }
                                },
                              )
                            ],
                          )
                        ]);
                  });
            },
            child: const Icon(Icons.add),
          ),
        ]));
  }
}
