import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/core/constants/strings.dart';
import 'package:shaunking_app/core/services/cache.dart';
import 'package:shaunking_app/core/widgets/loading.dart';
import 'package:shaunking_app/views/screens/auth/login_screen.dart';
import 'package:shaunking_app/views/screens/home_screen.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  void _navigateNext() async {
    String email = await readCache(AppStrings.userEmail) ?? '';

    await Future.delayed(const Duration(seconds: 2));
    if (email.isNotEmpty) {
      Get.offAll(const HomeScreen());
    } else {
      Get.offAll(const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/images/logo.png',
              // width: 300,
              // height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
