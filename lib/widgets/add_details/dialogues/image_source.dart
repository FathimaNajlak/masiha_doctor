import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masiha_doctor/providers/doc_details_provider.dart'; // Ensure you have this package in your pubspec.yaml

class ImageSourceDialog extends StatelessWidget {
  final DoctorDetailsProvider doctorDetailsProvider;

  const ImageSourceDialog({
    super.key,
    required this.doctorDetailsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Image Source'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              doctorDetailsProvider.pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              doctorDetailsProvider.pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  static void show(
      BuildContext context, DoctorDetailsProvider doctorDetailsProvider) {
    showDialog(
      context: context,
      builder: (context) =>
          ImageSourceDialog(doctorDetailsProvider: doctorDetailsProvider),
    );
  }
}
