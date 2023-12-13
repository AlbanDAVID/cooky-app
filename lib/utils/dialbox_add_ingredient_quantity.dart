// ignore_for_file: unnecessary_string_interpolations, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddIngredientQuantity extends StatefulWidget {
  const AddIngredientQuantity({super.key});

  @override
  State<AddIngredientQuantity> createState() => _AddIngredientQuantityState();
}

class _AddIngredientQuantityState extends State<AddIngredientQuantity> {
  List<int> numbers = List.generate(1000, (index) => index + 1);
  late List<String> units;

  List finalQuantity = ["", ""];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    units = AppLocalizations.of(context)!.listUnits.split(',');
  }

  void addQuantity(String value) {
    setState(() {
      finalQuantity.replaceRange(0, 1, [value]);
    });
  }

  void addUnit(String value) {
    setState(() {
      finalQuantity.replaceRange(1, 2, [value]);
    });
  }

  Widget displayQuantity(List value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value[0],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Text(
          value[1],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.quantity),
        ),
        body: Column(children: [
          SizedBox(
            height: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: numbers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${numbers[index]}',
                            textAlign: TextAlign.center),
                        onTap: () {
                          addQuantity('${numbers[index]}');
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: units.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(units[index], textAlign: TextAlign.center),
                        onTap: () {
                          addUnit('${units[index]}');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            child: displayQuantity(finalQuantity),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              label: Text(AppLocalizations.of(context)!.cancel),
            ),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context, finalQuantity);
              },
              label: Text(AppLocalizations.of(context)!.add),
            )
          ])
        ]));
  }
}
