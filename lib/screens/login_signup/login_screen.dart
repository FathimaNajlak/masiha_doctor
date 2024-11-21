import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/login_provider.dart';
import 'package:masiha_doctor/widgets/login/login_button.dart';
import 'package:masiha_doctor/widgets/login/login_form.dart';
import 'package:masiha_doctor/widgets/login/login_with.dart';
import 'package:masiha_doctor/widgets/login/sign_up.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Hello!',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF78A6B8),
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacementNamed(context, '/letin'),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                const SizedBox(height: 24),
                LoginButton(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                const SizedBox(height: 16),
                const LoginWith(),
                const SizedBox(height: 16),
                const SignUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
