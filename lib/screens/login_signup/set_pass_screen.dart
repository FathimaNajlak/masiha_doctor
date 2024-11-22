import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/set_pass_provider.dart';
import 'package:masiha_doctor/widgets/set_pass/button.dart';
import 'package:masiha_doctor/widgets/set_pass/confirm_pass.dart';
import 'package:masiha_doctor/widgets/set_pass/pass_field.dart';

import 'package:provider/provider.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SetPasswordProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Set Password',
            style: TextStyle(
              color: Color(0xFF7FBCD2),
              fontSize: 20,
            ),
          ),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 32),
                PasswordField(),
                SizedBox(height: 24),
                ConfirmPasswordField(),
                SizedBox(height: 32),
                CreatePasswordButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
