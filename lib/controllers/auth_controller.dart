import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shaunking_app/core/constants/strings.dart';
import 'package:shaunking_app/core/services/cache.dart';
import 'package:shaunking_app/views/screens/auth/login_screen.dart';
import 'package:shaunking_app/views/screens/home_screen.dart';
import 'package:shaunking_app/views/screens/welcome_screen.dart';

import '../core/services/google_auth_service.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString userPhone = ''.obs;
  RxString uID = 'akash13'.obs;

  @override
  void onInit() {
    super.onInit();
    readUser();
  }

  readUser() async {
    String name = await readCache(AppStrings.userName) ?? "";
    String email = await readCache(AppStrings.userEmail) ?? "";
    String phone = await readCache(AppStrings.userPhone) ?? "";
    String uid = await readCache(AppStrings.userUID) ?? "";

    userName(name);
    userEmail(email);
    userPhone(phone);
    if (uid.isNotEmpty) uID(uid);
  }

  Future<void> updateUser({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (name != null && name.isNotEmpty) {
      await writeCache(AppStrings.userName, name);
    }

    if (email != null && email.isNotEmpty) {
      await writeCache(AppStrings.userEmail, email);
    }

    if (phone != null && phone.isNotEmpty) {
      await writeCache(AppStrings.userPhone, phone);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final result = await GoogleAuthService().signInWithGoogle();

      if (result == null || result.user == null) {
        Get.snackbar('Login Failed', 'Google sign-in cancelled');
        return;
      }

      final user = result.user!;
      final name = user.displayName ?? '';
      final email = user.email ?? '';
      final uid = user.uid;

      // Save basic info to cache
      await writeCache(AppStrings.userEmail, email);
      await writeCache(AppStrings.userName, name);
      await writeCache(AppStrings.userUID, uid);

      // Save/update user in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
          {
            'fullName': name,
            'email': email,
            'profileImage': user.photoURL ?? '',
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(
              merge:
                  true)); // merge true ensures existing fields are not overwritten

      // Optionally, read user after saving
      await readUser();

      Get.offAll(const CategorySelectionScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await readUser();
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      await _googleSignIn.signOut(); // Ensure previous session is cleared
    } catch (e) {}
    Get.offAll(const LoginScreen());

    // Navigate back to login if needed
    // Get.offAll(() => LoginScreen());
  }

  Future<void> signUpWithEmail({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      final uid = user.uid;
      final fullName = '$firstName $lastName';

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'address': address,
        'authProvider': 'email',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await writeCache(AppStrings.userName, fullName);
      await writeCache(AppStrings.userEmail, email);
      await writeCache(AppStrings.userPhone, phone);
      await writeCache(AppStrings.userUID, uid);

      userName(fullName);
      userEmail(email);
      userPhone(phone);
      uID(uid);

      Get.offAll(const CategorySelectionScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Signup Failed',
          'An account already exists with this email',
        );
      } else if (e.code == 'weak-password') {
        Get.snackbar('Error', 'Password is too weak');
      } else {
        Get.snackbar('Error', e.message ?? 'Signup failed');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        Get.snackbar('Login Failed', 'User not found');
        return;
      }

      final uid = user.uid;

      // 🔹 Get user data from Firestore
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists) {
        Get.snackbar('Error', 'User data not found');
        return;
      }

      final data = doc.data()!;

      // 🔹 Cache user info
      await writeCache(AppStrings.userUID, uid);
      await writeCache(AppStrings.userEmail, data['email'] ?? '');
      await writeCache(AppStrings.userName, data['fullName'] ?? '');
      await writeCache(AppStrings.userPhone, data['phone'] ?? '');

      // 🔹 Update observable values
      userEmail(data['email'] ?? '');
      userName(data['fullName'] ?? '');
      userPhone(data['phone'] ?? '');
      uID(uid);

      // Get.offAll(() => const HomeScreen());
      Get.offAll(const CategorySelectionScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Login Failed', 'No account found with this email');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Login Failed', 'Incorrect password');
      } else {
        Get.snackbar('Login Failed', e.message ?? 'Login error');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
