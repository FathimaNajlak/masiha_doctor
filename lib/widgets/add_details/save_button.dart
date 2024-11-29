import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/colors.dart';
import 'package:masiha_doctor/providers/doctor_details.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return saveButton(context);
  }

  Widget saveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.read<DoctorProfileModel>().save(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkcolor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
