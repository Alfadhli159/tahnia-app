import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const MainButton({required this.title, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onTap, child: Text(title));
  }
}