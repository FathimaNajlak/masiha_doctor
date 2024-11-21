import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/signup_provider.dart';

class GenderDropdown extends StatelessWidget {
  final SignupProvider provider;
  const GenderDropdown({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: provider.selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
          .toList(),
      onChanged: (value) => provider.setGender(value!),
    );
  }
}
