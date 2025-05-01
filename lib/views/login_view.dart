

import 'package:darpik/controllers/auth_controller.dart';
import 'package:darpik/routes/app_pages.dart';
import 'package:darpik/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // لضبط النص لليسار
                  children: [
                    /// **🔹 عنوان الصفحة (Login)**
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double fontSize = constraints.maxWidth > 360 ? 26 : 22;
                        return Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),

                    /// **🔹 حقول الإدخال**
                    CustomTextField(
                      controller: controller.emailController,
                      label: 'Email',
                      validator: (value) {
                        if (!GetUtils.isEmail(value!)) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: controller.passwordController,
                      label: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    /// **🔹 زر تسجيل الدخول**
                    Obx(() => controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9C174E),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.login();
                              }
                            },
                            child: const Text('Login',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
                          )),
                    const SizedBox(height: 10),

                    /// **🔹 رابط إنشاء حساب جديد**
                    Center(
                      child: TextButton(
                        onPressed: () => Get.toNamed(Routes.REGISTER),
                        child: const Text('Create a new account',
                            style: TextStyle(color: Colors.black)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
