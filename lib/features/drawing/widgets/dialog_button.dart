import 'package:drawingapp/features/shared/colors.dart';
import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final Color? backgroundColor;

  final String title;
  final VoidCallback onPressed;
  const DialogButton(
      {super.key,
      this.backgroundColor,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor ?? primaryColor,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
