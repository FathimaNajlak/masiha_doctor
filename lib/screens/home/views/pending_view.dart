import 'package:flutter/material.dart';

class PendingView extends StatelessWidget {
  final VoidCallback onLogout;

  const PendingView({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.pending_actions,
            size: 64,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your request is under review',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please wait while we verify your details. This may take 24-48 hours.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
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
