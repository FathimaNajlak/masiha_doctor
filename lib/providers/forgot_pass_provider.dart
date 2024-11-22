import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  String _email = '';
  bool _isLoading = false;
  String? _errorMessage;

  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context) async {
    if (_email.isEmpty) {
      _errorMessage = 'Please enter your email';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();

      // Navigate to another page
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         const SetPasswordScreen(), // Replace with your target page
      //   ),
      // );
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
    }
  }
}
