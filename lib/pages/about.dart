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
                    const Text("BSD 3-Clause", textAlign: TextAlign.center)
                  ])),
                  ListTile(
                      title: Column(children: [
                    Text('${AppLocalizations.of(context)!.sourceCode} :',
                        textAlign: TextAlign.center),
                    ElevatedButton(
                      onPressed: () async {
                        _launchURL();
                      },
                      child: const Text(
                        "https://github.com/AlbanDAVID/cooky-app",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ])),
                  ListTile(
                      title: Column(children: [
                    Text('${AppLocalizations.of(context)!.version} : ',
                        textAlign: TextAlign.center),
                    Text(_packageInfo.version, textAlign: TextAlign.center)
                  ])),
                ]).toList(),
              ),
            ),
          ]),
          drawer: Drawer(
            backgroundColor: const Color.fromRGBO(234, 221, 255, 1.000),
            child: Column(children: [
              const DrawerHeader(
                  child: Icon(
                Icons.cookie,
                size: 48,
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
