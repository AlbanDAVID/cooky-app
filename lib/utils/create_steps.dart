// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

// dialog box for add steps (used in CreateSteps)
class DialogAddSteps extends StatelessWidget {
  final controller;
  //VoidCallback onSave;
  //VoidCallback onCancel;
  DialogAddSteps({
    super.key,
    required this.controller,
    //required this.onSave,
    //required this.onCancel,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // get user input
          SizedBox(
              height: 330,
              width: 500,
              child: TextField(
                maxLines:
                    null, // for automatically increase th height of TextField
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Write the step here.",
                ),
              )),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // save button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),

              // cancel button
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('OK'),
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
          title: const Text('Add steps'),
        ),
        body: Center(
            child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: stepsRecipe.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(' Step ${index + 1}:\n${stepsRecipe[index]}'));
              },
            )),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                    print('Received data from SecondScreen: $controller');
                    setState(() {});
                    stepsRecipe.add(controller);
                    numberSteps++;
                    _controller.clear();
                  }
                },
                child: Text("Add step $numberSteps"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, stepsRecipe);
                },
                child: Text("Finish"),
              ),
            ])
          ],
        )));
  }
}
