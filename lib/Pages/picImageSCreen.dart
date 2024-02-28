import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _imageFile;
  UploadTask? uploadTask;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image Screen"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                    onPressed: () {
                      uploadImage();
                    },
                    child: Text("Save Image to Storage"))
              ],
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

  uploadImage() async {
    try {
      setState(() {
        isLoading = true;
      });
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef = storage.ref().child("Statuses");
      uploadTask = storageRef
          .child("Images" + DateTime.now().toIso8601String())
          .putFile(_imageFile!);
      uploadTask!.then((TaskSnapshot snapshot) {
        // Handle completion here
        print("Upload complete!");
        snapshot.ref.getDownloadURL().then((String downloadURL) {
          // Store the download URL in a variable
          String url = downloadURL;

          // Now you can use 'url' variable to access the download URL
          print("Download URL: $url");
          Fluttertoast.showToast(
            msg: "Upload succesFull",
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return url;
        });
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle errors here
      print('Error picking image: $e');
    }
  }
}
