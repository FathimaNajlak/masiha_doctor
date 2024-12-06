// import 'package:flutter/material.dart';
// import 'package:masiha_doctor/models/doctor_model.dart';
// import 'package:masiha_doctor/providers/doc_details_provider.dart';
// import 'package:masiha_doctor/widgets/add_details/dialogues/certificate_source.dart';
// import 'dart:io';
// import 'package:path/path.dart'; // For basename
// import 'package:image_picker/image_picker.dart';

// class AddEducationDialog extends StatefulWidget {
//   final DoctorDetailsProvider provider;

//   const AddEducationDialog({super.key, required this.provider});

//   @override
//   _AddEducationDialogState createState() => _AddEducationDialogState();
// }

// class _AddEducationDialogState extends State<AddEducationDialog> {
//   final _formKey = GlobalKey<FormState>();
//   String? _degree;
//   String? _institution;
//   int? _yearOfCompletion;
//   File? _certificateFile;

//   void _pickCertificate(BuildContext context) async {
//     final result = await Navigator.push<File?>(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const CertificateSourceDialog(),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         _certificateFile = result;
//       });
//     }
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
//                 onSaved: (value) => _degree = value,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Institution',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter institution' : null,
//                 onSaved: (value) => _institution = value,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Year of Completion',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) => value?.isEmpty ?? true
//                     ? 'Please enter year'
//                     : (int.tryParse(value!) == null)
//                         ? 'Please enter valid year'
//                         : null,
//                 onSaved: (value) => _yearOfCompletion = int.tryParse(value!),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Upload Certificate',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               GestureDetector(
//                 onTap: () => _pickCertificate(context),
//                 child: Container(
//                   width: double.infinity,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: _certificateFile != null
//                       ? Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             const Icon(Icons.file_present, size: 40),
//                             Text(
//                               basename(_certificateFile!.path),
//                               textAlign: TextAlign.center,
//                             ),
//                             Positioned(
//                               top: 4,
//                               right: 4,
//                               child: IconButton(
//                                 icon: const Icon(Icons.close),
//                                 onPressed: () {
//                                   setState(() => _certificateFile = null);
//                                 },
//                               ),
//                             ),
//                           ],
//                         )
//                       : const Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.upload_file, size: 40),
//                             SizedBox(height: 8),
//                             Text('Tap to upload certificate'),
//                           ],
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () async {
//             if (_formKey.currentState!.validate()) {
//               _formKey.currentState!.save();
//               String? certificatePath;

//               // Save certificate if uploaded
//               if (_certificateFile != null) {
//                 certificatePath =
//                     await widget.provider.saveImageLocally(_certificateFile!);
//               }

//               // widget.provider.addEducation(
//               //   Education(
//               //     degree: _degree,
//               //     institution: _institution,
//               //     yearOfCompletion: _yearOfCompletion,
//               //     certificatePath: certificatePath,
//               //   ) as String,
//               // );
//               widget.provider.addEducation(
//                 _degree!,
//                 _institution!,
//                 _yearOfCompletion! as String,
//                 certificatePath,
//               );

//               Navigator.pop(context);
//             }
//           },
//           child: const Text('Add'),
//         ),
//       ],
//     );
//   }
// }
