// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DoctorProfileSetupScreen extends StatefulWidget {
//   const DoctorProfileSetupScreen({super.key});

//   @override
//   State<DoctorProfileSetupScreen> createState() =>
//       _DoctorProfileSetupScreenState();
// }

// class _DoctorProfileSetupScreenState extends State<DoctorProfileSetupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   final _bioController = TextEditingController();

//   List<String> _specializations = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadExistingProfile();
//   }

//   Future<void> _loadExistingProfile() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         final docSnapshot = await FirebaseFirestore.instance
//             .collection('doctors')
//             .doc(user.uid)
//             .get();

//         if (docSnapshot.exists) {
//           final data = docSnapshot.data();
//           if (data != null) {
//             setState(() {
//               _bioController.text = data['bio'] ?? '';

//               if (data['specializations'] != null) {
//                 _specializations = List<String>.from(data['specializations']);
//               }
//             });
//           }
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading profile: $e')),
//       );
//     }
//   }

//   String? _validateRequired(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }
//     if (value.trim().length < 50) {
//       return '$fieldName should be at least 50 characters';
//     }
//     return null;
//   }

//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance
//             .collection('doctors')
//             .doc(user.uid)
//             .set({
//           'bio': _bioController.text.trim(),
//           'specializations': _specializations,
//           'profileCompleted': true,
//           'lastUpdated': FieldValue.serverTimestamp(),
//         }, SetOptions(merge: true));

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profile saved successfully')),
//           );
//           Navigator.pop(context);
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving profile: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _bioController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complete Your Profile'),
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
//                     TextFormField(
//                       controller: _bioController,
//                       decoration: const InputDecoration(
//                         labelText: 'Professional Bio',
//                         border: OutlineInputBorder(),
//                         helperText: 'Write a detailed professional biography',
//                       ),
//                       maxLines: 5,
//                       validator: (value) => _validateRequired(value, 'Bio'),
//                     ),
//                     const SizedBox(height: 24),
//                     const Text(
//                       'Select Your Specializations',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     const SizedBox(height: 32),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _saveProfile,
//                         child: const Text('Save Profile'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:masiha_doctor/providers/doctor_profile_provider.dart';
import 'package:provider/provider.dart';

class DoctorProfileSetupScreen extends StatefulWidget {
  const DoctorProfileSetupScreen({super.key});

  @override
  State<DoctorProfileSetupScreen> createState() =>
      _DoctorProfileSetupScreenState();
}

class _DoctorProfileSetupScreenState extends State<DoctorProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProfileProvider>().loadProfile().then((_) {
        final profile = context.read<DoctorProfileProvider>().profile;
        _bioController.text = profile.bio;
        _consultationFeeController.text = profile.consultationFee.toString();
        _startTimeController.text = profile.workingHours['start'] ?? '';
        _endTimeController.text = profile.workingHours['end'] ?? '';
      });
    });
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final timeString = '${picked.hour}:${picked.minute}';
      if (isStartTime) {
        _startTimeController.text = timeString;
        context
            .read<DoctorProfileProvider>()
            .updateWorkingHours('start', timeString);
      } else {
        _endTimeController.text = timeString;
        context
            .read<DoctorProfileProvider>()
            .updateWorkingHours('end', timeString);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DoctorProfileProvider>();
    final profile = provider.profile;

    await provider.saveProfile(
      bio: _bioController.text.trim(),
      consultationFee: double.tryParse(_consultationFeeController.text) ?? 0.0,
      availability: profile.availability,
      workingHours: {
        'start': _startTimeController.text,
        'end': _endTimeController.text,
      },
      specializations: profile.specializations,
    );

    if (provider.error.isEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error)),
      );
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _consultationFeeController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: Consumer<DoctorProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Professional Bio',
                      border: OutlineInputBorder(),
                      helperText: 'Write a detailed professional biography',
                    ),
                    maxLines: 5,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Bio is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _consultationFeeController,
                    decoration: const InputDecoration(
                      labelText: 'Consultation Fee',
                      border: OutlineInputBorder(),
                      prefixText: '₹ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.trim().isEmpty
                        ? 'Consultation fee is required'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Working Hours',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Start Time',
                          ),
                          readOnly: true,
                          onTap: () => _selectTime(context, true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _endTimeController,
                          decoration: const InputDecoration(
                            labelText: 'End Time',
                          ),
                          readOnly: true,
                          onTap: () => _selectTime(context, false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Available Days',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...provider.profile.availability.entries.map(
                    (entry) => CheckboxListTile(
                      title: Text(entry.key),
                      value: entry.value,
                      onChanged: (bool? value) {
                        provider.updateAvailability(
                          entry.key,
                          value ?? false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Save Profile'),
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
