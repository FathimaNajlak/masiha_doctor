import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/contents.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final bool isDoctor;

  const PrivacyPolicyPage({super.key, required this.isDoctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: ${DateTime.now().toString().split(' ')[0]}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Information We Collect',
              isDoctor
                  ? Contents.doctorDataCollection
                  : Contents.patientDataCollection,
            ),
            _buildSection(
              context,
              'How We Use Your Information',
              isDoctor ? Contents.doctorDataUsage : Contents.patientDataUsage,
            ),
            _buildSection(
              context,
              'Data Security',
              Contents.dataSecurityText,
            ),
            _buildSection(
              context,
              'Your Rights',
              Contents.userRightsText,
            ),
            _buildSection(
              context,
              'Contact Us',
              Contents.contactInformation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
