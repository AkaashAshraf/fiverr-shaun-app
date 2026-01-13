import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shaunking_app/core/constants/strings.dart';
import 'package:shaunking_app/core/services/cache.dart';
import 'package:shaunking_app/views/screens/auth/login_screen.dart';
import 'package:shaunking_app/views/screens/home_screen.dart';

import '../core/services/google_auth_service.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString userPhone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    readUser();
  }

  readUser() async {
    String name = await readCache(AppStrings.userName) ?? "";
    String email = await readCache(AppStrings.userEmail) ?? "";
    String phone = await readCache(AppStrings.userPhone) ?? "";

    userName(name);
    userEmail(email);
    userPhone(phone);
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

      await writeCache(AppStrings.userEmail, email);
      await writeCache(AppStrings.userName, name);
      await writeCache(AppStrings.userUID, user.uid);
      await readUser();
      Get.offAll(() => const HomeScreen());
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
}
