import 'dart:developer';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shaunking_app/controllers/auth_controller.dart';
import 'package:shaunking_app/views/video_upload_screen.dart';

class WorkSignupController extends GetxController {
  final jobController = TextEditingController();
  final locationController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final AuthController authController = Get.find();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWorkData();
  }

  /// Load saved data from Firebase
  Future<void> loadWorkData() async {
    try {
      final uid = authController.uID.value;
      final doc = await firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data()!.containsKey('work')) {
        final data = doc['work'];
        jobController.text = data['jobTitle'] ?? '';
        locationController.text = data['location'] ?? '';
      }
    } catch (e) {
      debugPrint("Load error: $e");
    }
  }

  /// Save data to Firebase
  Future<void> saveWorkData() async {
    if (jobController.text.isEmpty && locationController.text.isEmpty) {
      Get.snackbar("Error", "Please enter details");
      return;
    }

    try {
      isLoading.value = true;
      final uid = authController.uID.value;

      await firestore.collection('users').doc(uid).set({
        'work': {
          'jobTitle': jobController.text.trim(),
          'location': locationController.text.trim(),
        }
      }, SetOptions(merge: true));
      Get.to(VideoUploadScreen());
      Get.snackbar("Success", "Saved successfully", colorText: Colors.white);
    } catch (e) {
      inspect(e);
      Get.snackbar("Error", "Failed to save", colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
