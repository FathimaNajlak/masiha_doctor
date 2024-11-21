import 'package:flutter/material.dart';
import 'package:masiha_doctor/services/firebase_auth_services.dart';

class LoginWith extends StatelessWidget {
  const LoginWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            'or sign up with',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final firebaseAuthService = FirebaseAuthService();
              final user = await firebaseAuthService.signInWithGoogle(context);
              if (user != null) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFF5F7FB),
              child: Image.asset(
                'assets/images/google.png',
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
