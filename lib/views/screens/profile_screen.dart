import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/controllers/profile_controller.dart';
import 'package:shaunking_app/core/constants/colors.dart';

class PersonalDataScreen extends StatelessWidget {
  PersonalDataScreen({super.key});
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      resizeToAvoidBottomInset: true, // important to prevent overflow
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 25),
                Center(child: _profilePic()),
                const SizedBox(height: 30),
                _input("Full Name & Surname", controller.fullNameController,
                    TextInputType.text),
                _input("Email Address", controller.emailController,
                    TextInputType.text),
                _input("Phone Number", controller.phoneController,
                    TextInputType.number),
                _dobPicker(context),
                const SizedBox(height: 30),
                _saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() => Row(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.white),
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: IconButton(
          //     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          //     onPressed: () => Get.back(),
          //   ),
          // ),
          // const Spacer(),
          // const Text(
          //   "Personal Data",
          //   style: TextStyle(color: Colors.white, fontSize: 18),
          // ),
          // const Spacer(),
        ],
      );

  Widget _profilePic() => Obx(() => GestureDetector(
        onTap: controller.pickImage,
        child: CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          backgroundImage: controller.localImage.value != null
              ? FileImage(controller.localImage.value as File)
              : controller.profileImageUrl.value.isNotEmpty
                  ? NetworkImage(controller.profileImageUrl.value)
                  : null,
          child: controller.profileImageUrl.value.isEmpty &&
                  controller.localImage.value == null
              ? const Icon(Icons.camera_alt, color: Colors.white)
              : null,
        ),
      ));

  Widget _input(String label, TextEditingController controller,
          TextInputType? type) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          TextField(
            controller: controller,
            keyboardType: type,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      );

  Widget _dobPicker(BuildContext context) => Obx(() => GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: controller.dob.value ?? DateTime(2000),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );
          if (date != null) controller.dob.value = date;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            controller.dob.value == null
                ? "Birth Date (Optional)"
                : "${controller.dob.value!.day} / "
                    "${controller.dob.value!.month} / "
                    "${controller.dob.value!.year}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ));

  Widget _saveButton() => Obx(() => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: controller.loading.value ? null : controller.saveProfile,
          child: controller.loading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Save"),
        ),
      ));
}
