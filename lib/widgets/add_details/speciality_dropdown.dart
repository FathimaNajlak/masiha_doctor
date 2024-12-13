import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/doc_details_provider.dart';

class SpecialtyDropdown extends StatelessWidget {
  const SpecialtyDropdown({
    super.key,
    required this.doctorDetailsProvider,
  });

  final DoctorDetailsProvider doctorDetailsProvider;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Specialty',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      value: doctorDetailsProvider.selectedSpecialty,
      items: doctorDetailsProvider.specialties.map((String specialty) {
        return DropdownMenuItem<String>(
          value: specialty,
          child: Text(specialty),
        );
      }).toList(),
      onChanged: (String? newValue) {
        doctorDetailsProvider.selectedSpecialty = newValue;
      },
      validator: doctorDetailsProvider.validateSpeciality,
      onSaved: (value) => doctorDetailsProvider.doctor.specialty = value,
    );
  }
}
