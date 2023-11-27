// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class AddDifficulty extends StatefulWidget {
  const AddDifficulty({super.key});

  @override
  State<AddDifficulty> createState() => _AddDifficultyState();
}

class _AddDifficultyState extends State<AddDifficulty> {
  final TextEditingController _controller = TextEditingController();
  final List<String> difficultyList = ["Easy", "Medium", "Hard"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add difficulty"),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
          SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: difficultyList.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      Navigator.pop(context, difficultyList[index]);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreen, // Couleur du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Bords arrondis
                      ),
                    ),
                    child: Center(
                      child: Text(
                        difficultyList[index],
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                  );
                },
              )),
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add difficulty'),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text('Add'),
                          onPressed: () async {
                            setState(() {
                              Navigator.pop(context);
                              difficultyList.insert(0, _controller.text);
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
