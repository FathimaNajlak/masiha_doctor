import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/set_pass_provider.dart';
import 'package:provider/provider.dart';

class CreatePasswordButton extends StatelessWidget {
  const CreatePasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SetPasswordProvider>();

    return ElevatedButton(
      onPressed: provider.isLoading
          ? null
          : () async {
              if (await provider.createNewPassword()) {
                // Navigate to next screen or show success message
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Password created successfully!'),
                //     backgroundColor: Colors.green,
                //   ),
                // );
                Navigator.pushNamed(context, '/allset');
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7FBCD2),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: provider.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'Create New Password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
