import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/patient_details_provider.dart';
import 'package:provider/provider.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String appointmentId;

  const PatientDetailsScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PatientDetailsProvider()..fetchPatientDetails(appointmentId),
      child: const PatientDetailsContent(),
    );
  }
}

class PatientDetailsContent extends StatelessWidget {
  const PatientDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PatientDetailsProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            provider.error!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    final details = provider.appointmentDetails;
    if (details == null) {
      return const Scaffold(
        body: Center(child: Text('No patient details found')),
      );
    }

    final patientDetails = details['patientDetails'] as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Patient Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailsRow('Name:', patientDetails['name'] ?? 'N/A'),
            const SizedBox(height: 10),
            _buildDetailsRow(
                'Age:', patientDetails['age']?.toString() ?? 'N/A'),
            const SizedBox(height: 10),
            _buildDetailsRow('Gender:', patientDetails['gender'] ?? 'N/A'),
            const SizedBox(height: 10),
            _buildDetailsRow('Phone:', patientDetails['phone'] ?? 'N/A'),
            const SizedBox(height: 10),
            _buildDetailsRow('Address:', patientDetails['address'] ?? 'N/A'),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Medical History:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildMedicalHistory(details['medicalHistory'] ?? []),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalHistory(List<dynamic> history) {
    if (history.isEmpty) {
      return const Text(
        'No medical history available.',
        style: TextStyle(fontSize: 16),
      );
    }

    return Column(
      children: history.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.medical_services, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
