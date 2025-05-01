import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // فرض اتجاه LTR على الحقل بالكامل
      textDirection: ui.TextDirection.ltr,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        textDirection: ui.TextDirection.ltr, // لضبط اتجاه النص داخل الحقل
        textAlign: TextAlign.left, // محاذاة النص داخل الحقل إلى اليسار
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          alignLabelWithHint: true, // لضمان محاذاة التسمية مع النص من اليسار
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: validator,
      ),
    );
  }
}
