import 'package:flutter/material.dart';
import 'package:masiha_doctor/widgets/login/forgot_pass/forgot_pass_button.dart';
import 'package:masiha_doctor/widgets/login/header.dart';
import 'package:masiha_doctor/widgets/login/login_form.dart';
import 'package:masiha_doctor/widgets/login/signup_prompt.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginHeader(),
              SizedBox(height: 30),
              LoginForm(),
              ForgotPasswordButton(),
              SizedBox(height: 20),
              SignUpPrompt(),
            ],
          ),
        ),
      ),
    );
  }
}
