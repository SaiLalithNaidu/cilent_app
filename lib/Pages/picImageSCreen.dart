import 'dart:io';

import 'package:client_app/modal/sampleModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionMessage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image Screen"),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
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
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: titleInput,
                      decoration: InputDecoration(
                          hintText: "Enter Title",
                          labelText: "Title",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: descriptionMessage,
                      minLines: 3,
                      maxLines: 6,
                      decoration: const InputDecoration(
                          hintText: "Message",
                          labelText: "Message",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            uploadImage();
                            uploadStatus();
                          },
                          child: Text("Save Image to Storage")),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> uploadStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      var mainImageUrl = await uploadImage();
      String docId = FirebaseFirestore.instance.collection("statuses").doc().id;
      SampleModel sampleObj = new SampleModel(
        docId,
        mainImageUrl.toString(),
        titleInput
            .text, // Access the current value of the title input controller
        descriptionMessage
            .text, // Access the current value of the description input controller
      );
      await FirebaseFirestore.instance
          .collection("statuses")
          .doc(sampleObj.docId)
          .set(sampleObj.toMap());

      Navigator.pop(context);

      Fluttertoast.showToast(
        msg: "Status uploaded successfully",
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // Handle errors here
      print('Error uploading status: $e');
      Fluttertoast.showToast(
        msg: "Error uploading status: $e",
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<dynamic> pickImage() async {
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

  Future<dynamic> uploadImage() async {
    try {
      setState(() {
        isLoading = true;
      });

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef = storage.ref().child("Statuses");
      TaskSnapshot snapshot = await storageRef
          .child("Images" + DateTime.now().toIso8601String())
          .putFile(_imageFile!);

      String downloadURL = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadURL");

      Fluttertoast.showToast(
        msg: "Image uploaded successfully",
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return downloadURL;
    } catch (e) {
      // Handle errors here
      print('Error uploading image: $e');
      throw e; // Rethrow the error to propagate it to the caller
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
