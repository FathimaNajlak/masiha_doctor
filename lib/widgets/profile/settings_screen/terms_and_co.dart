import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/contents.dart';

class TermsAndConditionsPage extends StatelessWidget {
  final bool isDoctor;

  const TermsAndConditionsPage({super.key, required this.isDoctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
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
              'Acceptance of Terms',
              Contents.acceptanceTerms,
            ),
            _buildSection(
              context,
              'User Obligations',
              isDoctor
                  ? Contents.doctorObligations
                  : Contents.patientObligations,
            ),
            _buildSection(
              context,
              'Service Description',
              Contents.serviceDescription,
            ),
            _buildSection(
              context,
              'Limitation of Liability',
              Contents.limitationLiability,
            ),
            _buildSection(
              context,
              'Termination',
              Contents.terminationTerms,
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
