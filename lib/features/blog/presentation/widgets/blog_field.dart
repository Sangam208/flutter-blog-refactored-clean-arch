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
      maxLines: null,
      controller: fieldController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 198, 198, 198),
        border: customBorder(),
        enabledBorder: customBorder(),
        focusedBorder: customBorder()
            .copyWith(borderSide: BorderSide(color: Colors.grey.shade300)),
        labelText: label,
      ),
    );
  }
}
