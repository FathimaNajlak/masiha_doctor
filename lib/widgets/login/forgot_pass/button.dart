import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/forgot_pass_provider.dart';
import 'package:provider/provider.dart';

class Button extends StatelessWidget {
  const Button({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForgotPasswordProvider>();

    return ElevatedButton(
      onPressed:
          provider.isLoading ? null : () => provider.resetPassword(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7FBCD2),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: provider.isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
