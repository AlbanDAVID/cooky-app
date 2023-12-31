/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_typing_uninitialized_variables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// dialog box for add steps (used in CreateSteps)
class DialogAddSteps extends StatelessWidget {
  final controller;
  //VoidCallback onSave;
  //VoidCallback onCancel;
  const DialogAddSteps({
    super.key,
    required this.controller,
    //required this.onSave,
    //required this.onCancel,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // get user input
          SizedBox(
              height: 130,
              width: 300,
              child: TextField(
                maxLines:
                    null, // for automatically increase the height of TextField
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.writeStep,
                ),
              )),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // save button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),

              // cancel button
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Text(AppLocalizations.of(context)!.add),
              )
            ],
          ),
        ],
      ),
    ));
  }
}

// dialog box for edit a  steps (used in CreateSteps)
class DialogEditStep extends StatelessWidget {
  final controller;

  //VoidCallback onSave;
  //VoidCallback onCancel;
  const DialogEditStep({
    super.key,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // get user input
          SizedBox(
              height: 130,
              width: 300,
              child: TextField(
                maxLines:
                    null, // for automatically increase the height of TextField
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // save button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),

              // cancel button
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Text(AppLocalizations.of(context)!.add),
              )
            ],
          ),
        ],
      ),
    ));
  }
}

// page for adding steps and show steps added before submit
class CreateSteps extends StatefulWidget {
  const CreateSteps({super.key});

  @override
  State<CreateSteps> createState() => _CreateStepsState();
}

class _CreateStepsState extends State<CreateSteps> {
  List<String> stepsRecipe = [];
  int numberSteps = 1;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addSteps),
        ),
        body: Center(
            child: Column(children: [
          Expanded(
              child: ListView.builder(
            itemCount: stepsRecipe.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                    ' ${AppLocalizations.of(context)!.step} ${index + 1}:\n${stepsRecipe[index]}'),
                trailing: Wrap(
                  spacing: -16,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (context) {
                              return DialogEditStep(
                                controller: TextEditingController(
                                    text: stepsRecipe[index].toString()),
                              );
                            });
                        if (result != null) {
                          String stepEdited = result;
                          setState(() {});
                          stepsRecipe[index] = stepEdited;
                        }
                      },
                    ),
                    GestureDetector(
                      onLongPress: () {
                        setState(() {
                          stepsRecipe.removeAt(index);
                        });
                      },
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              );
            },
          )),
          ElevatedButton(
            onPressed: () async {
              final result = await showDialog(
                  context: context,
                  builder: (context) {
                    return DialogAddSteps(
                      controller: _controller,
                    );
                  });
              if (result != null) {
                String controller = result;
                setState(() {});
                stepsRecipe.add(controller);
                numberSteps++;
                _controller.clear();
              }
            },
            child: Text(AppLocalizations.of(context)!.addNewStep),
          ),
          Container(
              padding: EdgeInsetsDirectional.all(20),
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, stepsRecipe);
                },
                child: Text(AppLocalizations.of(context)!.add),
              )),
        ])));
  }
}
