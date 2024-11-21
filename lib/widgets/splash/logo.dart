import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String imagepath;
  const LogoWidget({super.key, required this.imagepath});

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
