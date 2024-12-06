import 'package:flutter/material.dart';
import 'package:masiha_doctor/services/firebase_auth_services.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  String _email = '';
  bool _isLoading = false;
  String? _errorMessage;

  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setEmail(String value) {
    _email = value;
    _errorMessage = null;
    notifyListeners();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> resetPassword(BuildContext context) async {
    if (_email.isEmpty) {
      _errorMessage = 'Please enter your email';
      notifyListeners();
      return;
    }

    if (!isValidEmail(_email)) {
      _errorMessage = 'Please enter a valid email';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.sendPasswordResetEmail(_email);

      _isLoading = false;
      notifyListeners();

      // Show success dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Reset Link Sent'),
            content: const Text(
              'A password reset link has been sent to your email. Please check your inbox and follow the instructions.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.pushReplacementNamed(
                      context, '/login'); // Go to login
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to send reset link. Please try again.';
      notifyListeners();
    }
  }
}
