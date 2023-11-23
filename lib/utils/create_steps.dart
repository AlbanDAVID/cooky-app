// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class DialogExample extends StatelessWidget {
  final controller;
  //VoidCallback onSave;
  //VoidCallback onCancel;
  DialogExample({
    super.key,
    required this.controller,
    //required this.onSave,
    //required this.onCancel,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('STEP'),
        content: Container(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // get user input
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add a step",
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // save button
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
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
                    title: Text(' Step ${index + 1} :  ${stepsRecipe[index]}'));
              },
            )),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return DialogExample(
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
