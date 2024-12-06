import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masiha_doctor/models/doctor_model.dart';
import 'package:masiha_doctor/widgets/add_details/available_days.dart';
import 'package:masiha_doctor/widgets/add_details/date_input.dart';
import 'package:masiha_doctor/widgets/add_details/gender_dropdown.dart';
import 'package:masiha_doctor/widgets/add_details/profile_image.dart';
import 'package:masiha_doctor/widgets/add_details/save_button.dart';
import 'package:masiha_doctor/widgets/add_details/text_input.dart';
import 'package:masiha_doctor/widgets/add_details/working_time.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../providers/doc_details_provider.dart';

class DoctorDetailsPage extends StatelessWidget {
  const DoctorDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Doctor Details'),
      ),
      body: Consumer<DoctorDetailsProvider>(
        builder: (context, doctorDetailsProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: doctorDetailsProvider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImageWidget(provider: doctorDetailsProvider),
                  const SizedBox(height: 24),
                  TextInputWidget(
                    label: 'Full Name',
                    onSaved: (value) =>
                        doctorDetailsProvider.doctor.fullName = value,
                    validator: doctorDetailsProvider.validateName,
                  ),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => doctorDetailsProvider.doctor.age =
                        int.tryParse(value ?? ''),
                    validator: doctorDetailsProvider.validateAge,
                  ),
                  const SizedBox(height: 16),
                  DateInputWidget(provider: doctorDetailsProvider),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) =>
                        doctorDetailsProvider.doctor.email = value,
                    validator: doctorDetailsProvider.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  GenderDropdownWidget(provider: doctorDetailsProvider),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Hospital Name',
                    onSaved: (value) =>
                        doctorDetailsProvider.doctor.hospitalName = value,
                    validator: doctorDetailsProvider.validateHospitalName,
                  ),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Year of Experience',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => doctorDetailsProvider
                        .doctor.yearOfExperience = int.tryParse(value ?? ''),
                    validator: doctorDetailsProvider.validateYearOfExperience,
                  ),
                  const SizedBox(height: 16),
                  // AvailableDaysWidget(provider: doctorDetailsProvider),
                  const SizedBox(height: 16),
                  // WorkingTimeWidget(provider: doctorDetailsProvider),
                  const SizedBox(height: 16),
                  _buildEducationSection(context, doctorDetailsProvider),
                  const SizedBox(height: 16),
                  // TextInputWidget(
                  //   label: 'Consultation Fees',
                  //   keyboardType: TextInputType.number,
                  //   onSaved: (value) => doctorDetailsProvider
                  //       .doctor.consultationFees = double.tryParse(value ?? ''),
                  //   validator: doctorDetailsProvider.validateConsultationFees,
                  // ),
                  const SizedBox(height: 24),
                  NextButtonWidget(provider: doctorDetailsProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEducationSection(
      BuildContext context, DoctorDetailsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Education Qualifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddEducationDialog(context, provider),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.doctor.educations?.length ?? 0,
          itemBuilder: (context, index) {
            final education = provider.doctor.educations![index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                // Changed from children to child
                padding: const EdgeInsets.all(8),
                child: Row(
                  // Added child property here
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            education.degree ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(education.institution ?? ''),
                          Text('Year: ${education.yearOfCompletion}'),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () => provider.pickCertificate(index),
                        ),
                        if (education.certificatePath != null)
                          const Icon(Icons.check_circle, color: Colors.green),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => provider.removeEducation(index),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  void _showAddEducationDialog(
      BuildContext context, DoctorDetailsProvider provider) {
    final formKey = GlobalKey<FormState>();
    String? degree;
    String? institution;
    int? yearOfCompletion;
    File? certificateFile;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        // Added StatefulBuilder to update UI when certificate is picked
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Education'),
          content: SingleChildScrollView(
            // Added to handle overflow when keyboard appears
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Degree',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter degree' : null,
                    onSaved: (value) => degree = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Institution',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter institution'
                        : null,
                    onSaved: (value) => institution = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Year of Completion',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter year'
                        : (int.tryParse(value!) == null)
                            ? 'Please enter valid year'
                            : null,
                    onSaved: (value) => yearOfCompletion = int.tryParse(value!),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Upload Certificate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showCertificateSourceDialog(
                      context,
                      (File? file) {
                        if (file != null) {
                          setState(() => certificateFile = file);
                        }
                      },
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: certificateFile != null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(Icons.file_present, size: 40),
                                Text(
                                  basename(certificateFile!.path),
                                  textAlign: TextAlign.center,
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() => certificateFile = null);
                                    },
                                  ),
                                ),
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload_file, size: 40),
                                SizedBox(height: 8),
                                Text('Tap to upload certificate'),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  String? certificatePath;

                  // Save certificate if uploaded
                  if (certificateFile != null) {
                    certificatePath =
                        await provider.saveImageLocally(certificateFile!);
                  }

                  provider.addEducation(
                    Education(
                      degree: degree,
                      institution: institution,
                      yearOfCompletion: yearOfCompletion,
                      certificatePath: certificatePath,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCertificateSourceDialog(
      BuildContext context, Function(File?) onFileSelected) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Certificate Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  onFileSelected(File(pickedFile.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('File Upload'),
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  onFileSelected(File(pickedFile.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
