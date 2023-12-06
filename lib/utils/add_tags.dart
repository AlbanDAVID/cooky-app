// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTags extends StatefulWidget {
  const AddTags({super.key});

  @override
  State<AddTags> createState() => _AddTagsState();
}

class _AddTagsState extends State<AddTags> {
  late List<String> tags;

  final List selectedTags = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    tags = AppLocalizations.of(context)!.listTags.split(',');
  }

  @override
  Widget build(BuildContext context) {
    // add list from dialbox_add_ingredient to allIngredientSelected
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add tags'),
        ),
        body: Column(children: [
          const Text("Suggestions : ", style: TextStyle(fontSize: 13)),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50, top: 0),
            child: ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTags.add(
                        tags[index],
                      );
                    });
                  },
                  child: Text(
                    tags[index],
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
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.add),
                          onPressed: () async {
                            selectedTags.add(
                              _controller.text,
                            );
                            Navigator.pop(context);

                            _controller.clear();

                            setState(() {});
                          },
                        )
                      ],
                    );
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
