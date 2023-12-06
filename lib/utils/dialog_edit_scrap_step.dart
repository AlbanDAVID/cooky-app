import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogEditStep extends StatelessWidget {
  final controller;

  const DialogEditStep({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SizedBox(
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
                    null, // for automatically increase the height of TextField
                controller: controller,
                decoration: const InputDecoration(
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
                child: Text(AppLocalizations.of(context)!.saveChanges),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
