import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/controllers/auth_controller.dart';
import 'package:shaunking_app/core/constants/colors.dart';
import 'package:shaunking_app/views/screens/auth/forget_password_screen.dart';
import 'package:shaunking_app/views/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  /// Use existing controller (do NOT create new one)
  final AuthController authController = Get.find<AuthController>();

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    authController.loginWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Logo
              Image.asset(
                'assets/images/logo.png',
                height: 200,
              ),
              const SizedBox(height: 40),

              /// Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              /// Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              /// Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(const ForgotPasswordScreen());
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Login Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: _login,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Google Login
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    'Login with Google',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    authController.loginWithGoogle();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              /// Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.offAll(const SignUpScreen());
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
