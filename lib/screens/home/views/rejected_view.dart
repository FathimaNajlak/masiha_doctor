import 'package:flutter/material.dart';

class RejectedView extends StatelessWidget {
  final VoidCallback onLogout;

  const RejectedView({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your request was not approved',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please contact support for more information.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onLogout,
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
