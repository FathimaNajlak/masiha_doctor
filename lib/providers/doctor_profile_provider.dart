import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProfile {
  final String bio;
  final double consultationFee;
  final Map<String, bool> availability;
  final Map<String, String> workingHours;
  final List<String> specializations;

  DoctorProfile({
    this.bio = '',
    this.consultationFee = 0.0,
    this.availability = const {
      'Monday': false,
      'Tuesday': false,
      'Wednesday': false,
      'Thursday': false,
      'Friday': false,
      'Saturday': false,
      'Sunday': false,
    },
    this.workingHours = const {'start': '', 'end': ''},
    this.specializations = const [],
  });
}

class DoctorProfileProvider extends ChangeNotifier {
  DoctorProfile _profile = DoctorProfile();
  bool _isLoading = false;
  String _error = '';

  DoctorProfile get profile => _profile;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null) {
            _profile = DoctorProfile(
              bio: data['bio'] ?? '',
              consultationFee: (data['consultationFee'] ?? 0.0).toDouble(),
              availability: data['availability'] != null
                  ? Map<String, bool>.from(data['availability'])
                  : {
                      'Monday': false,
                      'Tuesday': false,
                      'Wednesday': false,
                      'Thursday': false,
                      'Friday': false,
                      'Saturday': false,
                      'Sunday': false,
                    },
              workingHours: data['workingHours'] != null
                  ? Map<String, String>.from(data['workingHours'])
                  : {'start': '', 'end': ''},
              specializations: data['specializations'] != null
                  ? List<String>.from(data['specializations'])
                  : [],
            );
          }
        } else {
          // For a new doctor, create a completely empty profile
          _profile = DoctorProfile(
            bio: '',
            consultationFee: 0.0,
            availability: {
              'Monday': false,
              'Tuesday': false,
              'Wednesday': false,
              'Thursday': false,
              'Friday': false,
              'Saturday': false,
              'Sunday': false,
            },
            workingHours: {'start': '', 'end': ''},
            specializations: [],
          );
        }
      }
    } catch (e) {
      _error = 'Error loading profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile({
    required String bio,
    required double consultationFee,
    required Map<String, bool> availability,
    required Map<String, String> workingHours,
    required List<String> specializations,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Current User UID: ${user.uid}');
        final doctorData = {
          'bio': bio,
          'consultationFee': consultationFee,
          'specializations': specializations,
          'availability': availability,
          'workingHours': workingHours,
          'profileCompleted': true,
          'lastUpdated': FieldValue.serverTimestamp(),
          'doctorId': user.uid,
        };
        print('Saving Doctor Data: $doctorData');

        // Update the existing document in the 'doctors' collection
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(user.uid)
            .set(doctorData, SetOptions(merge: true));

        _profile = DoctorProfile(
          bio: bio,
          consultationFee: consultationFee,
          availability: availability,
          workingHours: workingHours,
          specializations: specializations,
        );
      } else {
        // Throw an error if no user is authenticated
        throw Exception('No authenticated user found');
      }
    } catch (e) {
      _error = 'Error saving profile: $e';
      print('Save Profile Error: $e'); // Add detailed error logging
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateAvailability(String day, bool value) {
    final newAvailability = Map<String, bool>.from(_profile.availability);
    newAvailability[day] = value;
    _profile = DoctorProfile(
      bio: _profile.bio,
      consultationFee: _profile.consultationFee,
      availability: newAvailability,
      workingHours: _profile.workingHours,
      specializations: _profile.specializations,
    );
    notifyListeners();
  }

  void updateWorkingHours(String key, String value) {
    final newWorkingHours = Map<String, String>.from(_profile.workingHours);
    newWorkingHours[key] = value;
    _profile = DoctorProfile(
      bio: _profile.bio,
      consultationFee: _profile.consultationFee,
      availability: _profile.availability,
      workingHours: newWorkingHours,
      specializations: _profile.specializations,
    );
    notifyListeners();
  }
}
