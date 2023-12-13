/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

import 'package:Cooky/data/language_database/language_database.dart';
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
    return PopScope(
        canPop: false,
        child: Scaffold(
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
          drawer: Drawer(
            backgroundColor: const Color.fromRGBO(234, 221, 255, 1.000),
            child: Column(children: [
              DrawerHeader(
                  child: Image.asset(
                "android/app/src/main/res/mipmap-hdpi/ic_launcher.png",
              )),
              // home page list tile
              ListTile(
                leading: const Icon(Icons.home),
                title: Text(AppLocalizations.of(context)!.home),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/home');
                },
              ),
              ListTile(
                leading: const Icon(Icons.language_sharp),
                title: Text(AppLocalizations.of(context)!.language),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/language');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(AppLocalizations.of(context)!.about),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/about');
                },
              )
            ]),
          ),
        ));
  }
}
