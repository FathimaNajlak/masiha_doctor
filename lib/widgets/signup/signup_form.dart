import 'package:flutter/material.dart';
import 'package:masiha_doctor/form_container.dart';
import 'package:masiha_doctor/services/firebase_auth_services.dart';
import 'package:masiha_doctor/widgets/costum_button.dart';
import 'package:masiha_doctor/widgets/utils/validation_logic.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSigningUp = true;
    });

    try {
      await _auth.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User is successfully created")),
        );
        Navigator.pushNamed(context, "/addDetails");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormContainerWidget(
            controller: _usernameController,
            hintText: "Username",
            isPasswordField: false,
            validator: ValidationUtil.validateUsername,
          ),
          const SizedBox(height: 10),
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
            text: "Sign Up",
            isLoading: isSigningUp,
            onTap: _signUp,
          ),
        ],
      ),
    );
  }
}
