import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController fieldController;
  final FormFieldValidator validator;
  final bool isObscureText;
  const AuthField(
      {super.key,
      required this.hintText,
      required this.fieldController,
      required this.validator,
      this.isObscureText = false});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder customBorder() {
      return OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(226, 251, 116, 0.694)),
      );
    }

    return TextFormField(
      obscureText: isObscureText,
      controller: fieldController,
      decoration: InputDecoration(
        errorBorder: customBorder(),
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        hintText: hintText,
        border: customBorder(),
        enabledBorder: customBorder(),
        focusedBorder: customBorder(),
      ),
      validator: validator,
    );
  }
}
