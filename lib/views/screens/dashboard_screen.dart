import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/controllers/auth_controller.dart';
import 'package:shaunking_app/core/constants/colors.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  // Get the AuthController instance
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header (dynamic)
              Row(
                children: [
                  const Text(
                    'Welcome, ',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${authController.userName.value.isNotEmpty ? authController.userName.value : 'User'}!',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'Here is your summary for today',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),

              // Summary Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildDashboardCard('Orders', '24', Icons.shopping_cart),
                  _buildDashboardCard('Sales', '\$1,250', Icons.attach_money),
                  _buildDashboardCard(
                      'Notifications', '5', Icons.notifications),
                  _buildDashboardCard('Problems', '2', Icons.report_problem),
                ],
              ),
              const SizedBox(height: 30),

              // Recent Activity Header
              const Text(
                'Recent Activity',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Recent Activity List
              Column(
                children: [
                  _buildActivityItem('Order #1234 delivered', '2 hours ago'),
                  _buildActivityItem(
                      'New notification received', '3 hours ago'),
                  _buildActivityItem('Order #1235 pending', '5 hours ago'),
                  _buildActivityItem('Problem reported by user', '1 day ago'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dashboard Card Widget
  Widget _buildDashboardCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 30),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Recent Activity Item Widget
  Widget _buildActivityItem(String title, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: AppColors.scaffoldBackground,
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.circle, size: 12, color: Colors.blue),
        title: Text(title),
        subtitle: Text(time),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Handle activity tap
        },
      ),
    );
  }
}
