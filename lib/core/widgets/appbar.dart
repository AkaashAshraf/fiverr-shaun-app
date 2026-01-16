import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/core/constants/colors.dart';

class MyAppBar extends StatelessWidget {
  final Widget end;
  final String title;

  const MyAppBar({
    super.key,
    required this.end,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white, // border color
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
        const Spacer(),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: end,
        ),
      ],
    ).paddingOnly(bottom: 10);
  }
}
