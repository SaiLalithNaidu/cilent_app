import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../modal/editModel.dart';

class EditScreen extends StatefulWidget {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? docId;

  const EditScreen(
      {Key? key, this.docId, this.title, this.description, this.imageUrl})
      : super(key: key);

  @override
  State<EditScreen> createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  bool isLoading = false;
  File? _editImage;
  String? _newImageUrl;
  TextEditingController editTittle = TextEditingController();
  TextEditingController editedDescription = TextEditingController();
  String? _descrption;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with received values
    editTittle.text = widget.title ?? '';
    editedDescription.text = widget.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Screen"),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            widget.imageUrl == null
                ? Text("No Image File Choosen")
                : Image.network(
                    _newImageUrl ?? widget.imageUrl!,
                    width: 350,
                    height: 200,
                  ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ElevatedButton(
                onPressed: () {
                  editImage();
                },
                child: const Text("Edit Image")),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: editTittle,
              decoration: const InputDecoration(
                  hintText: "Enter Title",
                  labelText: "Title",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: editedDescription,
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
                  child: Text("Update")),
            )
          ],
        ),
      )
          // Provide a child widget when not loading
          ),
    );
  }

  Future<dynamic> editImage() async {
    // Use try-catch to handle any errors during image picking
    try {
      final XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _editImage = File(pickedImage.path); // Convert XFile to File
          _newImageUrl = null;
        });

        // Show the picked image in the UI
        _newImageUrl =
            await uploadImage(); // Update _newImageUrl with the new image URL
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
          .putFile(_editImage!);

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

  Future<dynamic> uploadStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      var mainImageUrl = await uploadImage();
      // Use widget.imageUrl to access the passed imageUrl
      EditedModelStatus sampleObj = new EditedModelStatus(
        widget.docId,
        _newImageUrl ?? widget.imageUrl ?? '',
        editTittle.text,
        editedDescription.text,
      );
      await FirebaseFirestore.instance
          .collection("statuses")
          .doc(sampleObj.docId)
          .update(sampleObj.toMap());

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
}
