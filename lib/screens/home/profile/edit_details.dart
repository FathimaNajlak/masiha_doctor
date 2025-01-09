import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/doc_details_provider.dart';
import 'package:masiha_doctor/widgets/add_details/education_section.dart';
import 'package:masiha_doctor/widgets/add_details/profile_image.dart';
import 'package:provider/provider.dart';
import 'package:masiha_doctor/models/doctor_model.dart';

class DoctorDetailsEditPage extends StatefulWidget {
  const DoctorDetailsEditPage({super.key});

  @override
  State<DoctorDetailsEditPage> createState() => _DoctorDetailsEditPageState();
}

class _DoctorDetailsEditPageState extends State<DoctorDetailsEditPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _experienceController = TextEditingController();
  final _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final provider = Provider.of<DoctorDetailsProvider>(context, listen: false);
    await provider.fetchDoctorDetails();
    _populateFields(provider.doctor);
  }

  void _populateFields(DoctorDetailsModel doctor) {
    _nameController.text = doctor.fullName ?? ''; // Updated to use fullName
    _emailController.text = doctor.email ?? '';
    _ageController.text = doctor.age?.toString() ?? '';
    _hospitalController.text = doctor.hospitalName ?? '';
    _experienceController.text = doctor.yearOfExperience?.toString() ?? '';
    _genderController.text = doctor.gender ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _hospitalController.dispose();
    _experienceController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Doctor Details'),
      ),
      body: Consumer<DoctorDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: provider.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image Section
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: provider.imageFile != null
                              ? FileImage(provider.imageFile!)
                              : (provider.doctor.imagePath != null
                                  ? NetworkImage(provider.doctor.imagePath!)
                                  : null) as ImageProvider?,
                          child: (provider.imageFile == null &&
                                  provider.doctor.imagePath == null)
                              ? const Icon(Icons.person, size: 60)
                              : null,
                        ),
                        ProfileImageWidget(provider: provider),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: IconButton(
                        //     icon: const Icon(Icons.camera_alt),
                        //     onPressed: () =>
                        //         _showImagePickerOptions(context, provider),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  if (provider.imageError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        provider.imageError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Personal Information
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: provider.validateName,
                    onSaved: (value) => provider.doctor.fullName =
                        value, // Updated to use fullName
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: provider.validateEmail,
                    onSaved: (value) => provider.doctor.email = value,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: provider.validateAge,
                    onSaved: (value) =>
                        provider.doctor.age = int.tryParse(value ?? ''),
                  ),

                  const SizedBox(height: 16),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    value: provider.doctor.gender,
                    items: ['Male', 'Female', 'Other'].map((String gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      provider.doctor.gender = value;
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Specialty',
                      border: OutlineInputBorder(),
                    ),
                    value: provider.selectedSpecialty,
                    items: provider.specialties.map((String specialty) {
                      return DropdownMenuItem(
                        value: specialty,
                        child: Text(specialty),
                      );
                    }).toList(),
                    validator: provider.validateSpeciality,
                    onChanged: (String? value) {
                      provider.selectedSpecialty = value;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _hospitalController,
                    decoration: const InputDecoration(
                      labelText: 'Hospital Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: provider.validateHospitalName,
                    onSaved: (value) => provider.doctor.hospitalName = value,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _experienceController,
                    decoration: const InputDecoration(
                      labelText: 'Years of Experience',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: provider.validateYearOfExperience,
                    onSaved: (value) => provider.doctor.yearOfExperience =
                        int.tryParse(value ?? ''),
                  ),

                  const SizedBox(height: 24),

                  // Education Section

                  EducationSection(provider: provider),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (await provider.validateAndSave()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Details updated successfully!'),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                      child: provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Update Details'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
