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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF5DB6B1)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Color(0xFF5DB6B1)),
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
                    onChanged: (v) => setState(() => agree = v!),
                  ),
                  const Expanded(
                    child: Text(
                      'I agree to the Terms of Use',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Continue Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          authController.isLoading.value ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5DB6B1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: authController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'CONTINUE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 1.2,
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
          labelText: title, // 👈 stays visible when text is entered
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF5DB6B1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF5DB6B1), width: 2),
          ),
        ),
      ),
    );
  }
}
