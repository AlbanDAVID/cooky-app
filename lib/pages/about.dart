/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
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

  _launchURL(url) async {
    Uri _url = Uri.parse(url);
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.about),
          ),
          body: Column(children: [
            const Divider(),
            Expanded(
              child: ListView(
                children: ListTile.divideTiles(context: context, tiles: [
                  ListTile(
                      title: Column(children: [
                    Text('${AppLocalizations.of(context)!.version} : ',
                        textAlign: TextAlign.center),
                    Text(_packageInfo.version, textAlign: TextAlign.center)
                  ])),
                  ListTile(
                      title: Column(children: [
                    Text('${AppLocalizations.of(context)!.licence} : ',
                        textAlign: TextAlign.center),
                    const Text("GNU General Public License v3.0",
                        textAlign: TextAlign.center)
                  ])),
                  ListTile(
                      title: Column(children: [
                    Text('${AppLocalizations.of(context)!.contact}',
                        textAlign: TextAlign.center),
                    const SelectableText(
                      "albdav.cooky@gmail.com",
                      textAlign: TextAlign.center,
                    ),
                  ])),
                  ListTile(
                      title: Column(children: [
                    ElevatedButton(
                      onPressed: () async {
                        _launchURL('https://github.com/AlbanDAVID/Cooky-app');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.sourceCode,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _launchURL(
                            'https://github.com/AlbanDAVID/cooky-app/issues');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.reportIssue,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ])),
                  ListTile(
                      title: Column(children: [
                    Text('${AppLocalizations.of(context)!.supportMe}',
                        textAlign: TextAlign.center),
                    ElevatedButton(
                      onPressed: () async {
                        _launchURL('https://www.buymeacoffee.com/albdav');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.donate,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ])),
                  ListTile(
                      title: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.mood_sharp),
                      Text(' ${AppLocalizations.of(context)!.thxContrib}',
                          textAlign: TextAlign.center),
                    ]),
                    ListTile(
                      title: Text(
                          '${AppLocalizations.of(context)!.feelFreeContrib}',
                          textAlign: TextAlign.justify),
                    ),
                    ListTile(
                      title: Text('${AppLocalizations.of(context)!.dougy147}',
                          textAlign: TextAlign.justify),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _launchURL('https://github.com/dougy147');
                      },
                      child: const Text(
                        "dougy147 github",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ])),
                ]).toList(),
              ),
            ),
          ]),
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
