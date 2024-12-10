import 'package:flutter/material.dart';
import 'package:masiha_doctor/widgets/signup/footer.dart';
import 'package:masiha_doctor/widgets/signup/header.dart';
import 'package:masiha_doctor/widgets/signup/signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignUpHeader(),
                SizedBox(height: 30),
                SignUpForm(),
                SizedBox(height: 30),
                SignUpFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
