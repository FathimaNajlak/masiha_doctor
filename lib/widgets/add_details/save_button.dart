import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/colors.dart';
import 'package:masiha_doctor/providers/doc_details_provider.dart';

class NextButtonWidget extends StatelessWidget {
  final DoctorDetailsProvider provider;

  const NextButtonWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.darkcolor)),
        onPressed: provider.isLoading
            ? null
            : () async {
                if (await provider.validateAndSave()) {
                  Navigator.pushNamed(context, '/home');
                }
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: provider.isLoading
              ? const CircularProgressIndicator()
              : const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
