// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:masiha_doctor/models/doctor_model.dart';
// import 'package:masiha_doctor/providers/doc_details_provider.dart';
// import 'package:path/path.dart';

// class EducationDialog extends StatefulWidget {
//   final DoctorDetailsProvider provider;
//   final Function(Education) onSave;

//   const EducationDialog({
//     Key? key,
//     required this.provider,
//     required this.onSave,
//   }) : super(key: key);

//   @override
//   State<EducationDialog> createState() => _EducationDialogState();
// }

// class _EducationDialogState extends State<EducationDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late Education _education;
//   bool _isUploading = false;
//   File? _certificateFile;

//   @override
//   void initState() {
//     super.initState();
//     _education = Education();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add Education'),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Degree',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter degree' : null,
//                 onSaved: (value) => _education.degree = value,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Institution',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter institution' : null,
//                 onSaved: (value) => _education.institution = value,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Year of Completion',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: _validateYear,
//                 onSaved: (value) =>
//                     _education.yearOfCompletion = int.tryParse(value!),
//               ),
//               const SizedBox(height: 16),
//               _buildCertificateUploader(),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         if (_isUploading)
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: CircularProgressIndicator(strokeWidth: 2),
//           )
//         else
//           TextButton(
//             onPressed: _handleSubmit,
//             child: const Text('Add'),
//           ),
//       ],
//     );
//   }

//   Widget _buildCertificateUploader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Upload Certificate',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: _selectCertificate,
//           child: Container(
//             width: double.infinity,
//             height: 100,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: _buildCertificatePreview(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCertificatePreview() {
//     if (_certificateFile == null) {
//       return const Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.upload_file, size: 40),
//           SizedBox(height: 8),
//           Text('Tap to upload certificate'),
//         ],
//       );
//     }

//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         const Icon(Icons.file_present, size: 40),
//         Text(
//           basename(_certificateFile!.path),
//           textAlign: TextAlign.center,
//         ),
//         Positioned(
//           top: 4,
//           right: 4,
//           child: IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () => setState(() => _certificateFile = null),
//           ),
//         ),
//       ],
//     );
//   }

//   String? _validateYear(String? value) {
//     if (value?.isEmpty ?? true) return 'Please enter year';
//     final year = int.tryParse(value!);
//     if (year == null) return 'Please enter valid year';
    
//     final currentYear = DateTime.now().year;
//     if (year < 1900 || year > currentYear) {
//       return 'Please enter a year between 1900 and $currentYear';
//     }
//     return null;
//   }

//   Future<void> _selectCertificate() async {
//     final option = await showDialog<ImageSource>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Select Certificate Source'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera),
//               title: const Text('Camera'),
//               onTap: () => Navigator.pop(context, ImageSource.camera),
//             ),
//             ListTile(
//               leading: const Icon(Icons.upload_file),
//               title: const Text('File Upload'),
//               onTap: () => Navigator.pop(context, ImageSource.gallery),
//             ),
//           ],
//         ),
//       ),
//     );

//     if (option != null) {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: option,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );
//       if (pickedFile != null) {
//         setState(() => _certificateFile = File(pickedFile.path));
//       }
//     }
//   }

//   Future<void> _handleSubmit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_certificateFile == null) {
//       _showError('Please upload a certificate');
//       return;
//     }
    
//     setState(() => _isUploading = true);
//     try {
//       _formKey.currentState!.save();
      
//       // Upload certificate and get URL
//       await widget.provider.handleImageUpload(_certificateFile!);
//       if (widget.provider.imageError != null) {
//         _showError(widget.provider.imageError!);
//         return;
//       }
      
//       // Set the certificate path from the uploaded image URL
//       _education.certificatePath = widget.provider.doctor.imagePath;
      
//       // Call the onSave callback with the new education
//       widget.onSave(_education);
//       Navigator.pop(context);
//     } catch (e) {
//       _showError('Failed to save education details: $e');
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }

// // Helper function to show the dialog
// void showAddEducationDialog(
//   BuildContext context,
//   DoctorDetailsProvider provider,
//   Function(Education) onSave,
// ) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => EducationDialog(
//       provider: provider,
//       onSave: onSave,
//     ),
//   );
// }