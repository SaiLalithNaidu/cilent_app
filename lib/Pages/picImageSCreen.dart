import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image Screen"),
      ),
      body: Center(
        child: Column(
          children: [
            _imageFile == null
                ? Text("No Image File Choosen")
                : Image.file(_imageFile!),
            ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text("Upload Image")),
            ElevatedButton(
                onPressed: () {}, child: Text("Save Image to Storage"))
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    // Use try-catch to handle any errors during image picking
    try {
      final XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path); // Convert XFile to File
        });
      } else {
        // Handle the case when no image is picked
        print('No image selected.');
      }
    } catch (e) {
      // Handle errors here
      print('Error picking image: $e');
    }
  }

  uploadImage() {}
}
