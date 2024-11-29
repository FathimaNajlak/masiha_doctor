import 'package:flutter/material.dart';

class SetPasswordProvider extends ChangeNotifier {
  String _password = '';
  String _confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _passwordError;
  String? _confirmPasswordError;

  // Getters
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isLoading => _isLoading;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;

  void setPassword(String value) {
    _password = value;
    validatePassword();
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    validateConfirmPassword();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  bool validatePassword() {
    if (_password.isEmpty) {
      _passwordError = 'Password is required';
      return false;
    }
    if (_password.length < 8) {
      _passwordError = 'Password must be at least 8 characters';
      return false;
    }
    if (!_password.contains(RegExp(r'[A-Z]'))) {
      _passwordError = 'Password must contain at least one uppercase letter';
      return false;
    }
    if (!_password.contains(RegExp(r'[0-9]'))) {
      _passwordError = 'Password must contain at least one number';
      return false;
    }
    if (!_password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _passwordError = 'Password must contain at least one special character';
      return false;
    }
    _passwordError = null;
    return true;
  }

  bool validateConfirmPassword() {
    if (_confirmPassword.isEmpty) {
      _confirmPasswordError = 'Please confirm your password';
      return false;
    }
    if (_confirmPassword != _password) {
      _confirmPasswordError = 'Passwords do not match';
      return false;
    }
    _confirmPasswordError = null;
    return true;
  }

  Future<bool> createNewPassword() async {
    final isPasswordValid = validatePassword();
    final isConfirmPasswordValid = validateConfirmPassword();

    if (!isPasswordValid || !isConfirmPasswordValid) {
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
