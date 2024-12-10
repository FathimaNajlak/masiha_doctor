import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Login",
      style: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.bold,
        color: AppColors.darkcolor,
      ),
    );
  }
}
