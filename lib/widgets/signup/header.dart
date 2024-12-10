import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/colors.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Sign Up",
      style: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.bold,
        color: AppColors.darkcolor,
      ),
    );
  }
}
