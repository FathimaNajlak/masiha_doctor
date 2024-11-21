import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/signup_provider.dart';
import 'package:provider/provider.dart';

class TermsAndCo extends StatelessWidget {
  const TermsAndCo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        return Row(
          children: [
            Checkbox(
              value: provider.termsAccepted,
              onChanged: (value) {
                if (value != null) {
                  provider.toggleTerms(value);
                }
              },
              activeColor: const Color(0xFF78A6B8),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  children: [
                    const TextSpan(text: 'By continuing, you agree to '),
                    TextSpan(
                      text: 'Terms of Use',
                      style: TextStyle(color: Colors.blue[400]),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(color: Colors.blue[400]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
