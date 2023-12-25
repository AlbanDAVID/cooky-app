/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCost extends StatefulWidget {
  const AddCost({super.key});

  @override
  State<AddCost> createState() => _AddCostState();
}

class _AddCostState extends State<AddCost> {
  final TextEditingController _controller = TextEditingController();
  late List<String> costList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    costList = AppLocalizations.of(context)!.listCost.split(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addCost),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: [
            //IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
          SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: costList.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      Navigator.pop(context, costList[index]);
                    },
                    child: Center(
                      child: Text(
                        costList[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
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
                      title: Text(AppLocalizations.of(context)!.addCost),
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
