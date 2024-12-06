// import 'package:flutter/material.dart';
// import 'package:masiha_doctor/providers/doc_details_provider.dart';

// class AddEducationDialog {
//   static Future<void> show(
//       BuildContext context, DoctorDetailsProvider provider) async {
//     final TextEditingController degreeController = TextEditingController();
//     final TextEditingController institutionController = TextEditingController();
//     final TextEditingController yearController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add Education Qualification'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: degreeController,
//                 decoration: const InputDecoration(labelText: 'Degree'),
//               ),
//               TextField(
//                 controller: institutionController,
//                 decoration: const InputDecoration(labelText: 'Institution'),
//               ),
//               TextField(
//                 controller: yearController,
//                 keyboardType: TextInputType.number,
//                 decoration:
//                     const InputDecoration(labelText: 'Year of Completion'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Add the education details to the provider
//                 provider.addEducation(
//                   degreeController.text,
//                   institutionController.text,
//                   yearController.text,
                  
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
