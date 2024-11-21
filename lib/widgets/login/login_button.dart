import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masiha_doctor/consts/colors.dart';
import 'package:masiha_doctor/services/firebase_auth_services.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();

          if (formKey.currentState!.validate()) {
            final FirebaseAuthService authService = FirebaseAuthService();

            final user = await authService.signInWithEmailAndPassword(
              context: context,
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

            if (user != null) {
              Navigator.pushReplacementNamed(context, '/allset');
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fix the errors in the form'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkcolor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Log In',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
