import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: maxLines >= 1 ? maxLines : null,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing';
        } else {
          return null;
        }
      },
    );
  }
}