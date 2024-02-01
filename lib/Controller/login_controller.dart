import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modal/user/user.dart';

class Login_Controller extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  void onInit() {
    userCollection = firestore.collection('user');
    super.onInit();
  }

  addUser() {
    try {
      DocumentReference doc = userCollection.doc();
      User user = User(
        id: doc.id,
        name: 'Sri ram',
        number: 12345678901,
      );
      final productJson = user.toJson();
      doc.set(productJson);
      Get.snackbar('Success', 'User addded successfully',
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.green);
    }
  }
}
