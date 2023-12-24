/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyImagePickerPage extends StatefulWidget {
  const MyImagePickerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyImagePickerPageState createState() => _MyImagePickerPageState();
}

class _MyImagePickerPageState extends State<MyImagePickerPage> {
  File? _image;
  String? pathImageSelected;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Get the local storage directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String picturesDirPath = '${appDir.path}/Pictures';

      // Create the "Pictures" directory if it doesn't exist
      final Directory picturesDir = Directory(picturesDirPath);
      if (!picturesDir.existsSync()) {
        picturesDir.createSync();
      }

      // Generate a file name with a unique timestamp
      final String fileName =
          'image_${DateTime.now().millisecondsSinceEpoch}.png';

      // Save the image in the "Pictures" directory with the generated file name
      final String filePath = '$picturesDirPath/$fileName';
      await File(pickedFile.path).copy(filePath);

      setState(() {
        _image = File(filePath);
      });

      // You can now use the file name (fileName) if needed

      pathImageSelected = filePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addPicture),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.50,
                  maxWidth: MediaQuery.of(context).size.width * 0.95),
              child: _image == null
                  ? Text(AppLocalizations.of(context)!.noPic,
                      textAlign: TextAlign.center)
                  : Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(_image!),
                      ),
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text(AppLocalizations.of(context)!.chooseGallery),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text(AppLocalizations.of(context)!.takePic),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, pathImageSelected);
              },
              child: Text(AppLocalizations.of(context)!.addPicture2),
            ),
          ],
        ),
      ),
    );
  }
}
