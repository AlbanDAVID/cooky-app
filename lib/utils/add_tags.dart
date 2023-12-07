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
  List searchFiltred = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    tags = AppLocalizations.of(context)!.listTags.split(',');
    searchFiltred = tags;
  }

  // function to search
  void filterSearchResults(String query) {
    // get a list searchFiltred of the filtred search
    setState(() {
      searchFiltred = tags.where((item) {
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
          title: const Text('Add tags'),
          actions: [
            // IconButton(onPressed: () {showSearch(context: context, delegate: delegate)}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
          SearchBar(
            onChanged: (value) {
              filterSearchResults(value);
            },
            leading: const Icon(Icons.search),
            constraints: const BoxConstraints(
                minWidth: 200.0, maxWidth: 350.0, minHeight: 30.0),
            elevation: MaterialStateProperty.all(0),
            backgroundColor:
                MaterialStateProperty.all(Color.fromRGBO(240, 232, 252, 1)),
            shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )),
            hintText: AppLocalizations.of(context)!.searchTag,
            hintStyle:
                MaterialStateProperty.all(const TextStyle(color: Colors.grey)),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50, top: 0),
            child: ListView.builder(
              itemCount: searchFiltred.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTags.insert(0, searchFiltred[index]);
                    });
                  },
                  child: Text(
                    searchFiltred[index],
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
