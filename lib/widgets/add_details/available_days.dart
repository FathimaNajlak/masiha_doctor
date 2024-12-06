// import 'package:flutter/material.dart';
// import 'package:masiha_doctor/providers/doc_details_provider.dart';

// class AvailableDaysWidget extends StatelessWidget {
//   final DoctorDetailsProvider provider;

//   const AvailableDaysWidget({super.key, required this.provider});

//   @override
//   Widget build(BuildContext context) {
//     final availableDays = [
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday',
//       'Sunday'
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Available Days',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Wrap(
//           spacing: 8,
//           runSpacing: 4,
//           children: availableDays.map((day) {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Checkbox(
//                   value: provider.doctor.availableDays?.contains(day) ?? false,
//                   onChanged: (value) {
//                     if (value ?? false) {
//                       provider.doctor.availableDays ??= [];
//                       provider.doctor.availableDays!.add(day);
//                     } else {
//                       provider.doctor.availableDays?.remove(day);
//                     }
//                     provider.notifyListeners();
//                   },
//                 ),
//                 Text(day),
//               ],
//             );
//           }).toList(),
//         ),
//         if (provider.doctor.availableDays?.isEmpty ?? true)
//           Text(
//             'Please select at least one available day',
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.error,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//       ],
//     );
//   }
// }
