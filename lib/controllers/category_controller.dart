import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/views/screens/work_screen.dart';
import 'auth_controller.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxString selectedCategory = ''.obs;
  RxBool isLoading = false.obs;

  /// New: store all categories fetched from Firestore
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  String get uid => Get.put(AuthController()).uID.value;

  /// 🔥 Fetch category when screen opens (user's selected)
  Future<void> fetchCategory() async {
    if (uid.isEmpty) return;

    try {
      isLoading.value = true;

      // Fetch user's previously selected category
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data()!.containsKey('category')) {
        selectedCategory.value = doc['category'];
      }

      // Fetch all available categories from 'categories' collection
      final snapshot = await _firestore.collection('categories').get();
      categories.value =
          snapshot.docs.map((doc) => doc.data()).toList(); // List<Map>
    } catch (e) {
      print("Fetch Category Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 💾 Save category on Continue
  Future<void> saveCategory(String category) async {
    Get.to(WorkSignupScreen());

    if (uid.isEmpty) return;

    try {
      await _firestore.collection('users').doc(uid).set(
        {'category': category},
        SetOptions(merge: true),
      );
      selectedCategory.value = category; // update locally
    } catch (e) {
      print("Save Category Error: $e");
    }
  }
}
