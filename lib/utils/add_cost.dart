// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class AddCost extends StatefulWidget {
  const AddCost({super.key});

  @override
  State<AddCost> createState() => _AddCostState();
}

class _AddCostState extends State<AddCost> {
  final TextEditingController _controller = TextEditingController();
  final List<String> costList = [
    "Budget-friendly",
    "Average",
    "Expensive",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add cost"),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: [
            //IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
          const Text("Suggestions : ", style: TextStyle(fontSize: 10)),
          SizedBox(
              height: 500,
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
                      title: Text('Add cost'),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text('Add'),
                          onPressed: () async {
                            setState(() {
                              Navigator.pop(context);
                              costList.insert(0, _controller.text);
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
