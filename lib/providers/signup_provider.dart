import 'dart:io';
import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {
  DateTime? _selectedDate;
  String? _selectedGender;
  bool _termsAccepted = false;
  File? _selectedImage;

  DateTime? get selectedDate => _selectedDate;
  String? get selectedGender => _selectedGender;
  bool get termsAccepted => _termsAccepted;
  File? get selectedImage => _selectedImage;
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void toggleTerms(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  void setSelectedImage(File image) {
    _selectedImage = image;
    notifyListeners();
  }
}
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class SignupProvider with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   DateTime? _selectedDate;
//   String? _selectedGender;
//   bool _termsAccepted = false;
//   File? _selectedImage;
//   bool _isLoading = false;

//   // Getters
//   DateTime? get selectedDate => _selectedDate;
//   String? get selectedGender => _selectedGender;
//   bool get termsAccepted => _termsAccepted;
//   File? get selectedImage => _selectedImage;
//   bool get isLoading => _isLoading;

//   // Setters
//   void setDate(DateTime date) {
//     _selectedDate = date;
//     notifyListeners();
//   }

//   void setGender(String gender) {
//     _selectedGender = gender;
//     notifyListeners();
//   }

//   void toggleTerms(bool value) {
//     _termsAccepted = value;
//     notifyListeners();
//   }

//   void setSelectedImage(File image) {
//     _selectedImage = image;
//     notifyListeners();
//   }

//   // Firebase Authentication
//   Future<String?> signUp({
//     required String email,
//     required String password,
//     required String fullName,
//     required String age,
//   }) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       // Create user with email and password
//       final UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (userCredential.user != null) {
//         // Upload profile image if selected
//         String? profileImageUrl;
//         if (_selectedImage != null) {
//           profileImageUrl = await _uploadProfileImage(userCredential.user!.uid);
//         }

//         // Store user data in Firestore
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'fullName': fullName,
//           'email': email,
//           'age': age,
//           'gender': _selectedGender,
//           'dateOfBirth': _selectedDate?.toIso8601String(),
//           'profileImageUrl': profileImageUrl,
//           'createdAt': FieldValue.serverTimestamp(),
//         });

//         // Update display name
//         await userCredential.user!.updateDisplayName(fullName);
//         if (profileImageUrl != null) {
//           await userCredential.user!.updatePhotoURL(profileImageUrl);
//         }

//         _isLoading = false;
//         notifyListeners();
//         return null; // Success
//       }
//     } on FirebaseAuthException catch (e) {
//       _isLoading = false;
//       notifyListeners();

//       switch (e.code) {
//         case 'weak-password':
//           return 'The password provided is too weak.';
//         case 'email-already-in-use':
//           return 'An account already exists for that email.';
//         case 'invalid-email':
//           return 'The email address is not valid.';
//         default:
//           return 'An error occurred during signup. Please try again.';
//       }
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       return 'An unexpected error occurred. Please try again.';
//     }
//     return 'Failed to create account. Please try again.';
//   }

//   Future<String?> _uploadProfileImage(String userId) async {
//     try {
//       final ref = _storage.ref().child('profile_images').child('$userId.jpg');
//       await ref.putFile(_selectedImage!);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       debugPrint('Error uploading profile image: $e');
//       return null;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }