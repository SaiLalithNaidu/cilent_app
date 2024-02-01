import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

import '../modal/user/user.dart';

class Login_Controller extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  int? otpSend;
  int? otpEnter;
  void onInit() {
    userCollection = firestore.collection('user');
    super.onInit();
  }

  addUser() {
    try {
      if (otpSend == otpEnter) {
        DocumentReference doc = userCollection.doc();
        User user = User(
          id: doc.id,
          name: registerNameCtrl.text,
          number: int.parse(registerNumberCtrl.text),
        );
        final productJson = user.toJson();
        doc.set(productJson);
        Get.snackbar('Success', 'User addded successfully',
            colorText: Colors.green);
        registerNameCtrl.clear();
        registerNumberCtrl.clear();
        otpController.clear();
      } else {
        Get.snackbar('Error', 'Enter OTP Incoorect', colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.green);
    }
  }

  sendOtp() {
    try {
      if (registerNumberCtrl.text.isEmpty || registerNameCtrl.text.isEmpty) {
        Get.snackbar('Error', 'Pleas fill the Fields', colorText: Colors.red);
        return;
      }
      final random = Random();
      int otp = 1000 + random.nextInt(900);
      print(otp);
      if (otp != null) {
        otpFieldShown = true;
        otpSend = otp;
        Get.snackbar('Success', 'OTP sent Succesfully',
            colorText: Colors.green);
      } else {
        Get.snackbar('Error', 'OTP Not sent', colorText: Colors.red);
      }
    } catch (e) {
    } finally {
      update();
    }
  }
}
