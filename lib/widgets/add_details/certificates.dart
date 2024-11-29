import 'package:flutter/material.dart';

class AddCertificates extends StatelessWidget {
  const AddCertificates({super.key});

  @override
  Widget build(BuildContext context) {
    return certificatesSection();
  }

  Widget certificatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add your Experiences & Certificates',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              Icons.add_photo_alternate_outlined,
              size: 40,
              color: Colors.purple[400],
            ),
          ),
        ),
      ],
    );
  }
}
