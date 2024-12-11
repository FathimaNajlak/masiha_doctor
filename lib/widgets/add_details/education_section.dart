// lib/widgets/education_section.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masiha_doctor/models/doctor_model.dart';
import 'package:masiha_doctor/providers/doc_details_provider.dart';
import 'package:path/path.dart';

class EducationSection extends StatelessWidget {
  final DoctorDetailsProvider provider;

  const EducationSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Education Qualifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.all(8),
                child: Row(
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
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Education'),
          content: SingleChildScrollView(
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
                        await provider.updateDoctorImage(certificateFile!);
                    // await provider.saveImageLocally(certificateFile!);
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
