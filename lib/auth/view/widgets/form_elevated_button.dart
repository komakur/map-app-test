import 'package:flutter/material.dart';

class FormElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const FormElevatedButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.maxFinite, 46.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
