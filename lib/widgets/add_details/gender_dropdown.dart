// lib/widgets/add_details/gender_dropdown.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/doc_details_provider.dart';

class GenderDropdownWidget extends StatelessWidget {
  final DoctorDetailsProvider provider;

  const GenderDropdownWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      value: provider.doctor.gender,
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
          .toList(),
      onChanged: (value) {
        provider.doctor.gender = value;
      },
    );
  }
}
