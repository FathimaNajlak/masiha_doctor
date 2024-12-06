import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masiha_doctor/providers/doc_details_provider.dart';

class DateInputWidget extends StatelessWidget {
  final DoctorDetailsProvider provider;

  const DateInputWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
      text: provider.doctor.dateOfBirth != null
          ? DateFormat('dd/MM/yyyy').format(provider.doctor.dateOfBirth!)
          : '',
    );

    return TextFormField(
      controller: dateController,
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          provider.doctor.dateOfBirth = date;
          dateController.text = DateFormat('dd/MM/yyyy').format(date);
        }
      },
      validator: (value) =>
          provider.doctor.dateOfBirth == null ? 'Please select a date' : null,
    );
  }
}
