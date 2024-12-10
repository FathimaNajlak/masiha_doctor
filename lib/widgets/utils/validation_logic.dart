class ValidationUtil {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!emailPattern.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final passwordPattern = RegExp(r'^(?=.*\d)[A-Za-z\d]{6,}$');
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!passwordPattern.hasMatch(value)) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
