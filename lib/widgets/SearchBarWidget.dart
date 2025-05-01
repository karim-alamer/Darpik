import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: 'Search for a Place',
            hintStyle: TextStyle(
              color: Colors.grey[600],
              textBaseline: TextBaseline.alphabetic,
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.search,
                color: Color(0xFF006D2B),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
              right: 48,
            ),
          ),
        ),
      ),
    );
  }
}
