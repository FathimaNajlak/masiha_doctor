// user_provider.dart
// user_details_page.dart
import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/doc_details.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class UserDetailsPage extends StatelessWidget {
  const UserDetailsPage({super.key});

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
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: userProvider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileImage(context, userProvider),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Full Name',
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your name'
                        : null,
                    onSaved: (value) => userProvider.user.fullName = value,
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
                    onSaved: (value) =>
                        userProvider.user.age = int.tryParse(value ?? ''),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(context, userProvider),
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
                    onSaved: (value) => userProvider.user.email = value,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderDropdown(userProvider),
                  const SizedBox(height: 24),
                  _buildNextButton(context, userProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, UserProvider userProvider) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context, userProvider),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: userProvider.imageFile != null
            ? ClipOval(
                child: Image.file(
                  userProvider.imageFile!,
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

  Widget _buildDateField(BuildContext context, UserProvider userProvider) {
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
          userProvider.user.dateOfBirth = date;
        }
      },
      validator: (value) =>
          userProvider.user.dateOfBirth == null ? 'Please select a date' : null,
    );
  }

  Widget _buildGenderDropdown(UserProvider userProvider) {
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
      onChanged: (value) => userProvider.user.gender = value,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please select a gender' : null,
    );
  }

  Widget _buildNextButton(BuildContext context, UserProvider userProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: userProvider.isLoading
            ? null
            : () async {
                if (await userProvider.validateAndSave()) {
                  // Navigate to next page
                  Navigator.pushNamed(context, '/next-page');
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: userProvider.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Next'),
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, UserProvider userProvider) {
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
                userProvider.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                userProvider.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
