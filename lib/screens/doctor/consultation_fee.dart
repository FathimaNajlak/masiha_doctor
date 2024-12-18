// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ConsultationFeeSetupScreen extends StatefulWidget {
//   const ConsultationFeeSetupScreen({super.key});

//   @override
//   State<ConsultationFeeSetupScreen> createState() =>
//       _ConsultationFeeSetupScreenState();
// }

// class _ConsultationFeeSetupScreenState
//     extends State<ConsultationFeeSetupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _feeController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadExistingFee();
//   }

//   Future<void> _loadExistingFee() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         final docSnapshot = await FirebaseFirestore.instance
//             .collection('doctors')
//             .doc(user.uid)
//             .get();

//         if (docSnapshot.exists) {
//           final data = docSnapshot.data();
//           if (data != null && data['consultationFee'] != null) {
//             setState(() {
//               _feeController.text = data['consultationFee'].toString();
//             });
//           }
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error loading consultation fee: $e')),
//         );
//       }
//     }
//   }

//   Future<void> _saveConsultationFee() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance
//             .collection('doctors')
//             .doc(user.uid)
//             .update({
//           'consultationFee': double.parse(_feeController.text),
//           'feeLastUpdated': FieldValue.serverTimestamp(),
//         });

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text('Consultation fee saved successfully')),
//           );
//           Navigator.pop(context);
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving consultation fee: $e')),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Set Consultation Fee'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Set Your Consultation Fee',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'This is the amount you will charge for each consultation',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Card(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           children: [
//                             TextFormField(
//                               controller: _feeController,
//                               keyboardType:
//                                   const TextInputType.numberWithOptions(
//                                 decimal: true,
//                               ),
//                               decoration: const InputDecoration(
//                                 labelText: 'Consultation Fee',
//                                 prefixText: '\$',
//                                 border: OutlineInputBorder(),
//                                 helperText:
//                                     'Enter the amount you want to charge per consultation',
//                               ),
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                     RegExp(r'^\d+\.?\d{0,2}')),
//                               ],
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter a consultation fee';
//                                 }
//                                 final fee = double.tryParse(value);
//                                 if (fee == null) {
//                                   return 'Please enter a valid amount';
//                                 }
//                                 if (fee <= 0) {
//                                   return 'Fee must be greater than 0';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Tips:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             const Text(
//                               '• Consider your experience and specialization\n'
//                               '• Research market rates in your area\n'
//                               '• Factor in consultation duration\n'
//                               '• Account for platform fees if any',
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _saveConsultationFee,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         child: const Text('Save Consultation Fee'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     _feeController.dispose();
//     super.dispose();
//   }
// }
