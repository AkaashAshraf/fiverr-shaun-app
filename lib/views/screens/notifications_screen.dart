import 'package:flutter/material.dart';
import 'package:shaunking_app/core/constants/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {
      'title': 'Order #1234 delivered',
      'time': '2 hours ago',
    },
    {
      'title': 'New message from support',
      'time': '3 hours ago',
    },
    {
      'title': 'Order #1235 pending',
      'time': '5 hours ago',
    },
    {
      'title': 'Problem reported by user',
      'time': '1 day ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.appBarForeground,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return _buildNotificationItem(item['title']!, item['time']!);
        },
      ),
    );
  }

  Widget _buildNotificationItem(String title, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      color: AppColors.scaffoldBackground,
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.notifications, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.primary),
        ),
        subtitle: Text(
          time,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
