import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:masiha_doctor/consts/colors.dart';
import 'package:masiha_doctor/models/doctor_model.dart';
import 'package:masiha_doctor/providers/doc_details_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
                  _buildProfileImage(context, doctorDetailsProvider),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Full Name',
                    onSaved: (value) =>
                        doctorDetailsProvider.doctor.fullName = value,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => doctorDetailsProvider.doctor.age =
                        int.tryParse(value ?? ''),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(context, doctorDetailsProvider),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) =>
                        doctorDetailsProvider.doctor.email = value,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderDropdown(doctorDetailsProvider),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Hospital Name',
                    onSaved: (value) =>
                        doctorDetailsProvider.doctor.hospitalName = value,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Year of Experience',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => doctorDetailsProvider
                        .doctor.yearOfExperience = int.tryParse(value ?? ''),
                  ),
                  const SizedBox(height: 16),
                  _buildAvailableDaysCheckboxes(doctorDetailsProvider, context),
                  const SizedBox(height: 16),
                  _buildWorkingTimeField(context, doctorDetailsProvider),
                  const SizedBox(height: 16),
                  _buildEducationSection(context, doctorDetailsProvider),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Consultation Fees',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => doctorDetailsProvider
                        .doctor.consultationFees = double.tryParse(value ?? ''),
                  ),
                  const SizedBox(height: 24),
                  _buildNextButton(context, doctorDetailsProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(
      BuildContext context, DoctorDetailsProvider DoctorDetailsProvider) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context, DoctorDetailsProvider),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: DoctorDetailsProvider.imageFile != null
            ? ClipOval(
                child: Image.file(
                  DoctorDetailsProvider.imageFile!,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.person,
                size: 60,
                color: Colors.grey[400],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
    );
  }

  Widget _buildDateField(
      BuildContext context, DoctorDetailsProvider DoctorDetailsProvider) {
    return TextFormField(
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
          DoctorDetailsProvider.doctor.dateOfBirth = date;
        }
      },
      validator: (value) => DoctorDetailsProvider.doctor.dateOfBirth == null
          ? 'Please select a date'
          : null,
    );
  }

  Widget _buildGenderDropdown(DoctorDetailsProvider DoctorDetailsProvider) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
          .toList(),
      onChanged: (value) => DoctorDetailsProvider.doctor.gender = value,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please select a gender' : null,
    );
  }

  Widget _buildAvailableDaysCheckboxes(
      DoctorDetailsProvider DoctorDetailsProvider, BuildContext context) {
    final availableDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Days',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: availableDays.map((day) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: DoctorDetailsProvider.doctor.availableDays
                          ?.contains(day) ??
                      false,
                  onChanged: (value) {
                    if (value ?? false) {
                      DoctorDetailsProvider.doctor.availableDays ??= [];
                      DoctorDetailsProvider.doctor.availableDays!.add(day);
                    } else {
                      DoctorDetailsProvider.doctor.availableDays?.remove(day);
                    }
                    DoctorDetailsProvider.notifyListeners();
                  },
                ),
                Text(day),
              ],
            );
          }).toList(),
        ),
        if (DoctorDetailsProvider.doctor.availableDays?.isEmpty ?? true)
          Text(
            'Please select at least one available day',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
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

  Widget _buildWorkingTimeField(
      BuildContext context, DoctorDetailsProvider doctorDetailsProvider) {
    final startTime =
        doctorDetailsProvider.doctor.workingTimeStart ?? DateTime.now();
    final endTime = doctorDetailsProvider.doctor.workingTimeEnd ??
        DateTime.now().add(const Duration(hours: 8));

    // Format time to 12-hour format
    String formatTime(DateTime time) {
      return DateFormat.jm().format(time); // Example: "9:00 AM" or "5:00 PM"
    }

    // Initialize text controllers
    TextEditingController startTimeController =
        TextEditingController(text: formatTime(startTime));
    TextEditingController endTimeController =
        TextEditingController(text: formatTime(endTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Working Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: startTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  hintText: 'Select start time',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final newStartTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(startTime),
                      );
                      if (newStartTime != null) {
                        final newStartDateTime = DateTime(
                          startTime.year,
                          startTime.month,
                          startTime.day,
                          newStartTime.hour,
                          newStartTime.minute,
                        );
                        doctorDetailsProvider.doctor.workingTimeStart =
                            newStartDateTime;
                        startTimeController.text = formatTime(newStartDateTime);
                        doctorDetailsProvider.notifyListeners();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: endTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'End Time',
                  hintText: 'Select end time',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final newEndTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(endTime),
                      );
                      if (newEndTime != null) {
                        final newEndDateTime = DateTime(
                          endTime.year,
                          endTime.month,
                          endTime.day,
                          newEndTime.hour,
                          newEndTime.minute,
                        );
                        doctorDetailsProvider.doctor.workingTimeEnd =
                            newEndDateTime;
                        endTimeController.text = formatTime(newEndDateTime);
                        doctorDetailsProvider.notifyListeners();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextButton(
      BuildContext context, DoctorDetailsProvider DoctorDetailsProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.darkcolor)),
        onPressed: DoctorDetailsProvider.isLoading
            ? null
            : () async {
                if (await DoctorDetailsProvider.validateAndSave()) {
                  // Navigate to next page
                  Navigator.pushNamed(context, '/home');
                }
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: DoctorDetailsProvider.isLoading
              ? const CircularProgressIndicator()
              : const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(
      BuildContext context, DoctorDetailsProvider DoctorDetailsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                DoctorDetailsProvider.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                DoctorDetailsProvider.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
