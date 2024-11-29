import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/set_pass_provider.dart';
import 'package:provider/provider.dart';

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SetPasswordProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: provider.setConfirmPassword,
          obscureText: !provider.isConfirmPasswordVisible,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F7FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                provider.isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: provider.toggleConfirmPasswordVisibility,
            ),
            errorText: provider.confirmPasswordError,
          ),
        ),
      ],
    );
  }
}
