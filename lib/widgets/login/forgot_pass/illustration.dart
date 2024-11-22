import 'package:flutter/material.dart';

class IllustrationWidget extends StatelessWidget {
  const IllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/forgot_password.png',
        height: 350,
      ),
    );
  }
}
