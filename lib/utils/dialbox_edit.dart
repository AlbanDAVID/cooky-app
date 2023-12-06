import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// dialog box for add steps (used in CreateSteps)
// ignore: must_be_immutable
class DialogEditRecipeField extends StatelessWidget {
  final controller;
  final bool isFromScrap;
  VoidCallback showSuggestion;

  DialogEditRecipeField({
    super.key,
    required this.controller,
    required this.isFromScrap, // not used yet, but can be useful
    required this.showSuggestion,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
            height: 300,
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      )),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showSuggestion();
                        },
                        child:
                            Text(AppLocalizations.of(context)!.showSuggestion),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // save button
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),

                          // cancel button
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, controller.text),
                            child: Text(AppLocalizations.of(context)!.add),
                          )
                        ],
                      ),
                    ],
                  ),
                ])));
  }
}
