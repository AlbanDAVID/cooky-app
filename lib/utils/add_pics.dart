import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MyImagePickerPage extends StatefulWidget {
  @override
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
      print('Generated file name: $filePath');

      pathImageSelected = filePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No images selected.') : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Choose from gallery'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take a picture'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, pathImageSelected);
              },
              child: Text('Add picture'),
            ),
          ],
        ),
      ),
    );
  }
}
