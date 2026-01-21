import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/controllers/auth_controller.dart';
import 'package:shaunking_app/core/constants/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  bool agree = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (!agree) {
      Get.snackbar('Terms', 'Please agree to the Terms of Use');
      return;
    }

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    authController.signUpWithEmail(
      firstName: firstNameCtrl.text.trim(),
      lastName: lastNameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
    );
  }

  void _showTermsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Terms of Use',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'These are dummy terms of use.\n\n'
                  '1. This is a demo application.\n'
                  '2. Your data may be stored securely.\n'
                  '3. Do not misuse the app.\n'
                  '4. We are not responsible for any loss.\n'
                  '5. By using this app, you agree to all terms.\n\n'
                  'This content is just for testing UI.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _inputField(firstNameCtrl, 'First name'),
              _inputField(lastNameCtrl, 'Last name'),
              _inputField(
                emailCtrl,
                'Email Address',
                keyboard: TextInputType.emailAddress,
              ),
              _inputField(
                phoneCtrl,
                'Phone Number',
                keyboard: TextInputType.phone,
              ),
              _inputField(addressCtrl, 'Address'),
              _inputField(
                passwordCtrl,
                'Password',
                obscure: true,
              ),
              _inputField(
                confirmPasswordCtrl,
                'Confirm Password',
                obscure: true,
              ),
              const SizedBox(height: 12),

              /// Terms checkbox
              Row(
                children: [
                  Checkbox(
                    value: agree,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => agree = v!),
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        const Text('I agree to the '),
                        GestureDetector(
                          onTap: _showTermsBottomSheet,
                          child: const Text(
                            'Terms of Use',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Continue Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          authController.isLoading.value ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: authController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'CONTINUE',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String title, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
