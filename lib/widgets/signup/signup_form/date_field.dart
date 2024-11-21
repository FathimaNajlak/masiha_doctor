import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masiha_doctor/providers/signup_provider.dart';

class DateField extends StatelessWidget {
  final SignupProvider provider;
  const DateField({super.key, required this.provider});

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          errorInvalidText:
              provider.selectedDate == null ? 'Please select a date' : null,
        );
        if (picked != null) {
          provider.setDate(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Text(
          provider.selectedDate != null
              ? DateFormat('MM/dd/yyyy').format(provider.selectedDate!)
              : '',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
