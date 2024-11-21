import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'New Account',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF78A6B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
