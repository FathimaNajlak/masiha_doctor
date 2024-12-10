// lib/widgets/add_details/text_input.dart

import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final String label;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const TextInputWidget({
    super.key,
    required this.label,
    this.onSaved,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
