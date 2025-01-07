// ignore_for_file: avoid_print

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masiha_doctor/services/cloudinary_service.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masiha_doctor/models/doctor_model.dart';
import 'package:path_provider/path_provider.dart';

class DoctorDetailsProvider extends ChangeNotifier {
  final List<String> specialties = [
    'General Practice',
    'Internal Medicine',
    'Pediatrics',
    'Obstetrics and Gynecology',
    'Surgery',
    'Psychiatry',
    'Dermatology',
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Ophthalmology',
    'ENT (Otolaryngology)',
    'Urology',
    'Oncology',
    'Endocrinology',
    'Gastroenterology',
    'Pulmonology',
    'Nephrology',
    'Rheumatology',
    'Emergency Medicine',
    'General Dentistry',
  ];
  final DoctorDetailsModel _doctor = DoctorDetailsModel();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _imageError;
  final List<File> _certificateFiles = [];

  //
  DoctorDetailsModel get doctor => _doctor;
  File? get imageFile => _imageFile;
  GlobalKey<FormState> get formKey => _formKey;
  bool get isLoading => _isLoading;
  String? get imageError => _imageError;
  List<File> get certificateFiles => _certificateFiles;
  String? get selectedSpecialty => _doctor.specialty;

  set selectedSpecialty(String? value) {
    _doctor.specialty = value;
    notifyListeners();
  }

  // Validation Methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should only contain letters';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    if (age < 25 || age > 80) {
      return 'Age must be between 25 and 80';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateHospitalName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hospital name is required';
    }
    if (value.length < 3) {
      return 'Hospital name must be at least 3 characters';
    }
    return null;
  }

  String? validateYearOfExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'Years of experience is required';
    }
    final years = int.tryParse(value);
    if (years == null) {
      return 'Please enter a valid number';
    }
    if (years < 1 || years > 50) {
      return 'Experience must be between 1 and 50 years';
    }
    return null;
  }

  String? validateSpeciality(String? value) {
    if (value == null || value.isEmpty) {
      return 'Specialty is required';
    }
    if (!specialties.contains(value)) {
      return 'Please select a valid specialty';
    }
    return null;
  }

  String? validateDateOfBirth(DateTime? date) {
    if (date == null) {
      return 'Date of birth is required';
    }
    final age = DateTime.now().difference(date).inDays ~/ 365;
    if (age < 25 || age > 80) {
      return 'Age must be between 25 and 80 years';
    }
    return null;
  }

  bool validateEducation() {
    if (_doctor.educations == null || _doctor.educations!.isEmpty) {
      return false;
    }
    return _doctor.educations!.every((education) =>
        education.degree != null &&
        education.degree!.isNotEmpty &&
        education.institution != null &&
        education.institution!.isNotEmpty &&
        education.yearOfCompletion != null &&
        education.yearOfCompletion! > 1950 &&
        education.yearOfCompletion! <= DateTime.now().year);
  }

  // Image Handling Methods
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();

        // Validate file size (max 5MB)
        if (fileSize > 5 * 1024 * 1024) {
          _imageError = 'Image size should be less than 5MB';
          notifyListeners();
          return;
        }

        _imageFile = file;
        _imageError = null;
        notifyListeners();
      }
    } catch (e) {
      _imageError = 'Error picking image. Please try again.';
      notifyListeners();
    }
  }

  Future<String> updateDoctorImage(File imageFile) async {
    try {
      final cloudinaryUrl =
          await _cloudinaryService.uploadProfileImage(imageFile);
      notifyListeners();
      return cloudinaryUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  // Education Methods
  Future<void> addEducation(Education education) async {
    _doctor.educations ??= [];
    _doctor.educations!.add(education);
    notifyListeners();
  }

  Future<void> removeEducation(int index) async {
    if (_doctor.educations != null && _doctor.educations!.length > index) {
      // Remove the certificate file if it exists
      final certificatePath = _doctor.educations![index].certificatePath;
      if (certificatePath != null) {
        try {
          final certificateFile = File(certificatePath);
          if (await certificateFile.exists()) {
            await certificateFile.delete();
          }
        } catch (e) {
          // Handle file deletion error
          print('Error deleting certificate file: $e');
        }
      }

      _doctor.educations!.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> pickCertificate(int educationIndex) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();

        // Validate file size (max 5MB)
        if (fileSize > 5 * 1024 * 1024) {
          throw Exception('Certificate size should be less than 5MB');
        }

        _certificateFiles.add(file);
        _doctor.educations?[educationIndex].certificatePath = pickedFile.path;
        notifyListeners();
      }
    } catch (e) {
      // Handle certificate picking error
      print('Error picking certificate: $e');
      rethrow;
    }
  }

  // Main Validation and Save Method
  Future<bool> validateAndSave() async {
    // Reset any previous errors
    _imageError = _imageFile == null ? 'Profile image is required' : null;

    // Validate all required fields
    if (!_formKey.currentState!.validate()) {
      notifyListeners();
      return false;
    }

    // Validate non-form fields
    if (_imageFile == null) {
      _imageError = 'Profile image is required';
      notifyListeners();
      return false;
    }

    if (!validateEducation()) {
      // Handle education error
      return false;
    }

    // If all validation passes, proceed with saving
    _formKey.currentState!.save();
    setLoadingState(true);

    try {
      // Upload profile image to Supabase
      if (_imageFile != null) {
        final imageUrl = await updateDoctorImage(_imageFile!);
        // final imageUrl = await saveImageLocally(_imageFile!);
        _doctor.imagePath = imageUrl; // Store the public URL
      }

      // Similar modification for certificates
      await saveEducationCertificates();

      // Rest of your existing save logic
      await saveToFirestore('doctors', _doctor.toJson());
      await saveDoctorRequest();

      return true;
    } catch (e) {
      setLoadingState(false);
      throw Exception('Failed to save doctor details: $e');
    }
  }

  Future<void> saveEducationCertificates() async {
    for (var education in _doctor.educations ?? []) {
      if (education.certificatePath != null) {
        final certificateFile = File(education.certificatePath!);
        if (await certificateFile.exists()) {
          final savedCertificatePath = await updateDoctorImage(certificateFile);

          education.certificatePath = savedCertificatePath;
        }
      }
    }
  }

  // Future<void> saveToFirestore(
  //     String collection, Map<String, dynamic> data) async {
  //   await FirebaseFirestore.instance.collection(collection).add(data);
  // }
  Future<void> saveToFirestore(
      String collection, Map<String, dynamic> data) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .set(data, SetOptions(merge: true));
  }

  // Future<void> saveDoctorRequest() async {
  //   final userId = FirebaseAuth.instance.currentUser?.uid;
  //   if (userId == null) throw Exception('User not authenticated');

  //   final docRef =
  //       await FirebaseFirestore.instance.collection('doctorRequests').add({
  //     ...(_doctor.toJson()),
  //     'userId': userId,
  //     'requestStatus': RequestStatus.pending.name,
  //     'submittedAt': FieldValue.serverTimestamp(),
  //     'updatedAt': FieldValue.serverTimestamp(),
  //   });

  //   _doctor.requestId = docRef.id;
  //   _doctor.requestStatus = RequestStatus.pending;
  // }

  Future<void> saveDoctorRequest() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await FirebaseFirestore.instance
        .collection('doctorRequests')
        .doc(userId)
        .set({
      ...(_doctor.toJson()),
      'userId': userId,
      'requestStatus': RequestStatus.pending.name,
      'submittedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // Merge the new data with existing data

    _doctor.requestId = userId;
    _doctor.requestStatus = RequestStatus.pending;
  }

  void setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
