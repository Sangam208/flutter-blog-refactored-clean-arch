import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const AuthButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 13),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: const Color.fromARGB(255, 46, 151, 49),
      ),
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
