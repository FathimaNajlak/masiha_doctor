import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masiha_doctor/form_container.dart';
import 'package:masiha_doctor/services/firebase_auth_services.dart';
import 'package:masiha_doctor/widgets/costum_button.dart';
import 'package:masiha_doctor/widgets/login/google_sign_in.dart';
import 'package:masiha_doctor/widgets/utils/validation_logic.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSigning = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSigning = true);

      try {
        User? user = await _auth.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null && mounted) {
          Navigator.pushReplacementNamed(context, '/addDetails');
        }
      } finally {
        if (mounted) setState(() => _isSigning = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isSigning = true);

    try {
      User? user = await _auth.signInWithGoogle();

      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/addDetails');
      }
    } finally {
      if (mounted) setState(() => _isSigning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormContainerWidget(
            controller: _emailController,
            hintText: "Email",
            isPasswordField: false,
            validator: ValidationUtil.validateEmail,
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
            validator: ValidationUtil.validatePassword,
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: "Log In",
            isLoading: _isSigning,
            onTap: _handleLogin,
          ),
          const SizedBox(height: 10),
          SocialSignInButton(
            onPressed: _handleGoogleSignIn,
            isLoading: _isSigning,
          ),
        ],
      ),
    );
  }
}
