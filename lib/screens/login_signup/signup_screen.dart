import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/signup_provider.dart';
import 'package:masiha_doctor/widgets/login/login_with.dart';
import 'package:masiha_doctor/widgets/signup/header.dart';
import 'package:masiha_doctor/widgets/signup/login.dart';
import 'package:masiha_doctor/widgets/signup/next_button.dart';
import 'package:masiha_doctor/widgets/signup/pick_image.dart';
import 'package:masiha_doctor/widgets/signup/signup_form/signup_form.dart';
import 'package:masiha_doctor/widgets/signup/terms_and_co.dart';

import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Header(),
                const SizedBox(height: 15),
                Consumer<SignupProvider>(
                  builder: (context, provider, _) {
                    return FormField<String>(
                      validator: (value) {
                        if (provider.selectedImage == null) {
                          return 'Please select a profile image';
                        }
                        return null;
                      },
                      builder: (FormFieldState<String> state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ProfileImagePicker(
                              onImageSelected: (image) {
                                provider
                                    .setSelectedImage(image); // Update provider
                                state.didChange(
                                    'imageSelected'); // Notify form field of changeA
                              },
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),
                SignUpForm(formKey: _formKey),
                const SizedBox(height: 15),
                Consumer<SignupProvider>(
                  builder: (context, provider, _) {
                    return FormField<bool>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (!provider.termsAccepted) {
                          return 'Please accept the terms and conditions';
                        }
                        return null;
                      },
                      builder: (FormFieldState<bool> state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TermsAndCo(),
                            if (state.hasError)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 12),
                                child: Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),
                NextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Form is valid! Proceeding...')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please fill in all fields correctly')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 15),
                const LoginWith(),
                const Login(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
