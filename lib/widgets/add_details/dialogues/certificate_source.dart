import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CertificateSourceDialog extends StatelessWidget {
  const CertificateSourceDialog({super.key});

  Future<File?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Certificate Source'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(context, await _pickImage(ImageSource.camera));
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('File Upload'),
            onTap: () async {
              Navigator.pop(context, await _pickImage(ImageSource.gallery));
            },
          ),
        ],
      ),
    );
  }
}
