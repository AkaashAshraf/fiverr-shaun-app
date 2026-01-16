import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/controllers/auth_controller.dart';
import 'package:shaunking_app/core/constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: Container(),
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // User Header

          Container(
            width: double.infinity,
            // color: const Color.fromARGB(255, 236, 236, 236),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Obx(
              () => Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authController.userName.value.isNotEmpty
                            ? authController.userName.value
                            : 'User',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        authController.userEmail.value.isNotEmpty
                            ? authController.userEmail.value
                            : 'user@email.com',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.border,
          ),
          const SizedBox(height: 20),

          // Options List
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.logout, color: AppColors.textPrimary),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  onTap: () {
                    // Show confirmation popup
                    Get.defaultDialog(
                      title: 'Logout',
                      middleText: 'Are you sure you want to logout?',
                      textCancel: 'Cancel',
                      textConfirm: 'Logout',
                      confirmTextColor: Colors.white,
                      onConfirm: () async {
                        // Call logout from controller
                        await authController.logout();
                        Get.back(); // Close dialog
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
