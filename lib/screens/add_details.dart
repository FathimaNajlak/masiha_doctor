import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/colors.dart';
import 'package:masiha_doctor/providers/doc_details.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

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
        title: const Text('Add Details'),
      ),
      body: Consumer<DoctorDetailsProvider>(
        builder: (context, DoctorDetailsProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: DoctorDetailsProvider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileImage(context, DoctorDetailsProvider),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Full Name',
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your name'
                        : null,
                    onSaved: (value) =>
                        DoctorDetailsProvider.user.fullName = value,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true)
                        return 'Please enter your age';
                      final age = int.tryParse(value!);
                      if (age == null || age < 0) return 'Invalid age';
                      return null;
                    },
                    onSaved: (value) => DoctorDetailsProvider.user.age =
                        int.tryParse(value ?? ''),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(context, DoctorDetailsProvider),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true)
                        return 'Please enter your email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value!)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    onSaved: (value) =>
                        DoctorDetailsProvider.user.email = value,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderDropdown(DoctorDetailsProvider),
                  const SizedBox(height: 24),
                  _buildNextButton(context, DoctorDetailsProvider),
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
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
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
          DoctorDetailsProvider.user.dateOfBirth = date;
        }
      },
      validator: (value) => DoctorDetailsProvider.user.dateOfBirth == null
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
      onChanged: (value) => DoctorDetailsProvider.user.gender = value,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please select a gender' : null,
    );
  }

  Widget _buildNextButton(
      BuildContext context, DoctorDetailsProvider DoctorDetailsProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: DoctorDetailsProvider.isLoading
            ? null
            : () async {
                if (await DoctorDetailsProvider.validateAndSave()) {
                  // Navigate to next page
                  Navigator.pushNamed(context, '/home');
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: DoctorDetailsProvider.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Next',
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
