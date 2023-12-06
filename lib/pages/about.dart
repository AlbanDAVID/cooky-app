import 'package:cook_app/data/language_database/language_database.dart';
import 'package:cook_app/data/recipe_database/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  _launchURL() async {
    Uri _url = Uri.parse('https://github.com/AlbanDAVID/cooky-app');
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.about),
        ),
        body: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
                title: Column(children: [
              Text('${AppLocalizations.of(context)!.version} : '),
              Text(_packageInfo.version)
            ])),
            ListTile(
                title: Column(children: [
              Text('${AppLocalizations.of(context)!.licence} : '),
              const Text("BSD 3-Clause")
            ])),
            ListTile(
                title: Column(children: [
              Text(
                '${AppLocalizations.of(context)!.sourceCode} :',
              ),
              InkWell(
                onTap: _launchURL,
                child: const Text(
                  'https://github.com/AlbanDAVID/cooky-app',
                  textAlign: TextAlign.center,
                ),
              ),
            ])),
          ]).toList(),
        ));
  }
}
