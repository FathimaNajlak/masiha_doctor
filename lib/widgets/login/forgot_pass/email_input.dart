import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/forgot_pass_provider.dart';
import 'package:provider/provider.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForgotPasswordProvider>();

    return TextField(
      onChanged: provider.setEmail,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        hintText: 'Email',
        hintStyle: const TextStyle(color: Color.fromARGB(255, 201, 201, 201)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        errorText: provider.errorMessage,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
