import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shaunking_app/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Controllers (FIXES cursor issue)
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  Rx<DateTime?> dob = Rx<DateTime?>(null);
  RxString profileImageUrl = ''.obs;
  Rx<File?> localImage = Rx<File?>(null);

  RxBool loading = false.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  /// Fetch user data from Firestore
  Future<void> fetchProfile() async {
    final uid = authController.uID.value;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    fullNameController.text = data['fullName'] ?? '';
    emailController.text = data['email'] ?? '';
    phoneController.text = data['phone'] ?? '';
    profileImageUrl.value = data['profileImage'] ?? '';

    if (data['dob'] != null) {
      dob.value = (data['dob'] as Timestamp).toDate();
    }
  }

  /// Pick image + instant preview
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    localImage.value = File(picked.path);
    await uploadImage();
  }

  /// Upload image to Firebase Storage
  Future<void> uploadImage() async {
    if (localImage.value == null) return;

    final uid = authController.uID.value;
    final ref = _storage.ref().child('profile_images/$uid.jpg');

    await ref.putFile(localImage.value!);
    profileImageUrl.value = await ref.getDownloadURL();
  }

  /// Save profile to Firestore
  Future<void> saveProfile() async {
    loading.value = true;
    final uid = authController.uID.value;

    await _firestore.collection('users').doc(uid).set({
      'fullName': fullNameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'profileImage': profileImageUrl.value,
      'dob': dob.value != null ? Timestamp.fromDate(dob.value!) : null,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    loading.value = false;
    Get.snackbar("Success", "Profile updated");
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
