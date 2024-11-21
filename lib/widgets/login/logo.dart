import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  final String imagepath;
  const LoginWidget({super.key, required this.imagepath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Image.asset(
        imagepath,
        fit: BoxFit.contain,
      ),
    );
  }
}
