import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/core/constants/colors.dart';
import 'package:shaunking_app/controllers/work_signup_controller.dart';
import 'package:shaunking_app/core/widgets/appbar.dart';

class WorkSignupScreen extends StatelessWidget {
  WorkSignupScreen({super.key});

  final controller = Get.put(WorkSignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔝 Header
                const MyAppBar(
                    end: Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 20,
                    ),
                    title: "Sign Up - Work"),

                const SizedBox(height: 32),

                /// 🔍 Job Input
                _inputField(
                  controller: controller.jobController,
                  hint: "Job Title, Keywords or skills",
                  icon: Icons.search,
                  suffix: Icons.close,
                ),

                const SizedBox(height: 16),

                /// 📍 Location Input
                _inputField(
                  controller: controller.locationController,
                  hint: "Suburb, Town, City",
                  icon: Icons.location_on_outlined,
                ),

                const SizedBox(height: 24),

                /// OR
                Center(
                  child: Text(
                    "Or",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 📌 Use Location
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.my_location),
                    label: const Text("Use current location"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                /// ▶ Next Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveWorkData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Input Field Widget
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    IconData? suffix,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        suffixIcon: suffix != null
            ? Icon(suffix, color: AppColors.textSecondary)
            : null,
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
