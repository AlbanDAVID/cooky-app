import 'dart:io';
import 'package:cook_app/utils/create_recipe.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyImagePickerPage(),
    );
  }
}

class MyImagePickerPage extends StatefulWidget {
  @override
  _MyImagePickerPageState createState() => _MyImagePickerPageState();
}

class _MyImagePickerPageState extends State<MyImagePickerPage> {
  late File _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Get local save directory

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String appDirPath = appDir.path;

      // Create a “Pictures” subdirectory if it does not exist
      final String picturesDirPath = '$appDirPath/Pictures';
      final Directory picturesDir = Directory(picturesDirPath);
      if (!picturesDir.existsSync()) {
        picturesDir.createSync();
      }

      // Copy the image to the specified directory
      final String newPath =
          '$picturesDirPath/${DateTime.now().millisecondsSinceEpoch}.png';
      await File(pickedFile.path).copy(newPath);

      setState(() {
        _image = File(newPath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _image == null
        ? Image.asset('recipe_pics/photo_boeuf_bourguignon.jpg',
            width: 100, height: 100) // Placeholder image
        : Image.file(_image!);
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('Aucune image sélectionnée.')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Choisir depuis la galerie'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Prendre une photo'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  Navigator.pop(context, _image);
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
