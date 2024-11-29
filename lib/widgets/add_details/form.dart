import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/doctor_details.dart';
import 'package:provider/provider.dart';

class DetailsForm extends StatelessWidget {
  const DetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return form(context);
  }

  Widget form(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(
          label: 'Category',
          value: context.watch<DoctorProfileModel>().category,
          onChanged: (value) {
            context.read<DoctorProfileModel>().updateCategory(value ?? '');
          },
          items: ['General', 'Specialist', 'Surgeon'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildTextField(label: 'Hospital Name'),
        const SizedBox(height: 16),
        _buildTextField(label: 'Years of Experience'),
        const SizedBox(height: 16),
        _buildTextField(label: 'Working Time'),
        const SizedBox(height: 16),
        _buildTextField(label: 'Consultation Fees'),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required void Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value.isEmpty ? null : value,
            hint: Text(label),
            isExpanded: true,
            underline: Container(),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        TextField(
          decoration: InputDecoration(
            // hintText: 'text',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}
