import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/forgot_pass_provider.dart';
import 'package:masiha_doctor/widgets/login/forgot_pass/button.dart';
import 'package:masiha_doctor/widgets/login/forgot_pass/email_input.dart';
import 'package:masiha_doctor/widgets/login/forgot_pass/illustration.dart';

import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Forgot password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Enter your Email and we will send you\na password reset link',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 32),
                  EmailInput(),
                  SizedBox(height: 24),
                  IllustrationWidget(),
                  SizedBox(height: 32),
                  Button(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
