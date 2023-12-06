import 'package:cook_app/data/language_database/language_database.dart';
import 'package:cook_app/data/recipe_database/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  // load database language
  LanguageDatabase db = LanguageDatabase();
  final _myBox = Hive.box('mybox');

  late List supportedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    supportedLanguage =
        AppLocalizations.of(context)!.supportedLanguage.split(',');
  }

  // convert supportedLanguage to appropriate name for localization
  convertSupportedLanguageForLocalization(index) {
    if (index == 0) {
      return "en";
    } else if (index == 1) {
      return "fr";
    } else if (index == 3) {
      return null; // because if locale is null : flutter wil take the locale language of the phone
    }
  }

  // dialbox to ask to restart the app for take effect
  void dialbox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const SizedBox(
            height: 100.0,
            child: Text(
              'Please restart your application \n \n Merci de redémarrer votre application',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.ok,
                style: const TextStyle(color: Colors.lightGreen),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
      ),
      body: ListView.builder(
          itemCount: supportedLanguage.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(supportedLanguage[index]),
              onTap: () {
                setState(() {
                  _myBox.put("LANGUAGE",
                      convertSupportedLanguageForLocalization(index));
                });
                dialbox();
              },
            );
          }),
    );
  }
}
