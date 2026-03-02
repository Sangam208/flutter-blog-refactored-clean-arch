import 'package:flutter/material.dart';

class BlogField extends StatelessWidget {
  final String label;
  final TextEditingController fieldController;

  const BlogField({
    super.key,
    required this.label,
    required this.fieldController,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder customBorder() {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      );
    }

    return TextFormField(
      validator: (value) {
        return value == null || value.isEmpty ? "$label is missing" : null;
      },
      maxLines: null,
      controller: fieldController,
      decoration: InputDecoration(
        errorBorder: customBorder(),
        filled: true,
        fillColor: const Color.fromARGB(255, 198, 198, 198),
        border: customBorder()
            .copyWith(borderSide: BorderSide(color: Colors.grey.shade700)),
        enabledBorder: customBorder(),
        focusedBorder: customBorder()
            .copyWith(borderSide: BorderSide(color: Colors.grey.shade700)),
        labelText: label,
      ),
    );
  }
}
