import 'package:flutter/material.dart';

class FormHeaderText extends StatelessWidget {
  const FormHeaderText(this.text, {super.key});

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
