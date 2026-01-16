import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shaunking_app/controllers/category_controller.dart';
import 'package:shaunking_app/core/constants/colors.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final CategoryController controller = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    controller.fetchCategory(); // Load from Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            // Show loader if categories are empty
            if (controller.categories.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                /// 🔙 Back Button
                if (false)
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios,
                        color: AppColors.textPrimary),
                  ),

                const SizedBox(height: 16),

                /// 🧾 Title
                Text(
                  "Welcome!",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Please select your category",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 24),

                /// 🧩 Category List
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final cat = controller.categories[index];
                      return _categoryTile(
                        title: cat['title'] ?? '',
                        subtitle: cat['subtitle'] ?? '',
                        icon: _getIconData(cat['icon'] ?? ''),
                      );
                    },
                  ),
                ),

                /// ▶ Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: controller.selectedCategory.value.isEmpty
                        ? null
                        : () {
                            controller.saveCategory(
                                controller.selectedCategory.value);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// 🧩 Category Tile
  Widget _categoryTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool isSelected = controller.selectedCategory.value == title;

    return GestureDetector(
      onTap: () => controller.selectedCategory.value = title,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            /// Icon
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(width: 14),

            /// Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Map string to IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'apartment':
        return Icons.apartment;
      case 'groups':
        return Icons.groups;
      case 'grass':
        return Icons.grass;
      default:
        return Icons.category;
    }
  }
}
