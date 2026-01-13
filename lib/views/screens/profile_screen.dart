import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/controllers/auth_controller.dart';
import 'package:shaunking_app/core/constants/colors.dart';
import 'package:shaunking_app/views/screens/auth/change_password_screen.dart';
import 'package:shaunking_app/views/screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.appBarForeground,
        leading: Container(),
        title: const Text("Profile"),
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          // User Header
          if (false)
            Obx(() => Container(
                  width: double.infinity,
                  color: AppColors.primary,
                  padding: const EdgeInsets.only(
                      top: 80, left: 20, right: 20, bottom: 40),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
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
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            authController.userEmail.value.isNotEmpty
                                ? authController.userEmail.value
                                : 'user@email.com',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),

          const SizedBox(height: 20),

          // Profile Details
          Expanded(
            child: Obx(() => ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildProfileItem(
                        'Username',
                        authController.userName.value.isNotEmpty
                            ? authController.userName.value
                            : ''),
                    _buildProfileItem(
                        'Email',
                        authController.userEmail.value.isNotEmpty
                            ? authController.userEmail.value
                            : ''),
                    _buildProfileItem(
                        'Phone',
                        authController.userPhone.value.isNotEmpty
                            ? authController.userPhone.value
                            : ''),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const EditProfileScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                                fontSize: 16, color: AppColors.textPrimary),
                          ),
                        ),
                      ),
                    ),
                    if (false)
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('Change Password'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.to(const ChangePasswordScreen());
                        },
                      ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.textHint),
      ),
      color: AppColors.scaffoldBackground,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
