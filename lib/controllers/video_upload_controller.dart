import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shaunking_app/controllers/auth_controller.dart';

class VideoUploadController extends GetxController {
  var localVideoPath = ''.obs;
  var uploadedVideoUrl = ''.obs;
  var isLoading = false.obs;

  final picker = ImagePicker();
  final firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find();

  // TODO: Replace with your Cloudinary values
  final String cloudName = "dhwlgrrxt";
  final String uploadPreset = "unsigned_videos";

  @override
  void onInit() {
    super.onInit();
    loadExistingVideo();
  }

  /// Pick a video from the gallery
  Future<void> pickVideo() async {
    try {
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null && File(pickedFile.path).existsSync()) {
        localVideoPath.value = pickedFile.path;
      } else {
        // Get.snackbar("Error", "No video selected");
      }
    } catch (e) {
      Get.snackbar("Error", "Video pick failed");
    }
  }

  /// Load existing video URL from Firestore
  Future<void> loadExistingVideo() async {
    final uid = authController.uID.value;
    if (uid.isEmpty) return;

    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data()!.containsKey('videoUrl')) {
        uploadedVideoUrl.value = doc['videoUrl'];
      }
    } catch (e) {
      print("Load existing video error: $e");
    }
  }

  /// Upload video to Cloudinary
  Future<void> saveChanges() async {
    final uid = authController.uID.value;
    if (uid.isEmpty) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    if (localVideoPath.value.isEmpty) {
      Get.snackbar("Error", "No video selected");
      return;
    }

    final file = File(localVideoPath.value);
    if (!file.existsSync()) {
      Get.snackbar("Error", "File doesn't exist");
      return;
    }

    try {
      isLoading.value = true;

      // Prepare Cloudinary upload URL
      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/video/upload",
      );

      final request = http.MultipartRequest("POST", uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath("file", file.path));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
// final response = await request.send();
// final respStr = await response.stream.bytesToString();
      print("Cloudinary Response: $respStr");

      final data = json.decode(respStr);

      if (data['secure_url'] != null) {
        final videoUrl = data['secure_url'];

        // Save to Firestore
        await firestore.collection('users').doc(uid).set(
          {
            'videoUrl': videoUrl,
          },
          SetOptions(merge: true),
        );

        uploadedVideoUrl.value = videoUrl;
        localVideoPath.value = '';

        Get.snackbar("Success", "Video uploaded successfully");
      } else {
        Get.snackbar("Error", "Upload failed");
      }
    } catch (e) {
      print("Cloudinary upload error: $e");
      Get.snackbar("Error", "Video upload failed");
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove video URL from Firestore (optional)
  Future<void> deleteVideoCompletely() async {
    final uid = authController.uID.value;
    if (uid.isEmpty) return;

    try {
      await firestore.collection('users').doc(uid).set({
        'videoUrl': FieldValue.delete(),
      }, SetOptions(merge: true));

      uploadedVideoUrl.value = '';
      Get.snackbar("Success", "Video removed from profile");
    } catch (e) {
      print("Error deleting video reference: $e");
      Get.snackbar("Error", "Failed to remove video");
    }
  }
}
