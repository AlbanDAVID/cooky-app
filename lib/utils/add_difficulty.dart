// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddDifficulty extends StatefulWidget {
  const AddDifficulty({super.key});

  @override
  State<AddDifficulty> createState() => _AddDifficultyState();
}

class _AddDifficultyState extends State<AddDifficulty> {
  final TextEditingController _controller = TextEditingController();
  late List<String> difficultyList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    difficultyList = AppLocalizations.of(context)!.listDifficulty.split(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addDifficulty),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: [
            // IconButton(onPressed: () {}, icon: const Icon(Icons.search))
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
                    child: Center(
                      child: Text(
                        difficultyList[index],
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
                      title: Text(AppLocalizations.of(context)!.addDifficulty),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.add),
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
