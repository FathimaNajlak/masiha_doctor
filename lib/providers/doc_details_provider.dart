import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masiha_doctor/models/doctor_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class DoctorDetailsProvider extends ChangeNotifier {
  final User _user = User();
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  User get user => _user;
  File? get imageFile => _imageFile;
  GlobalKey<FormState> get formKey => _formKey;
  bool get isLoading => _isLoading;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<String> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
    final savedImage = await imageFile.copy('${directory.path}/$fileName');
    return savedImage.path;
  }

  Future<bool> validateAndSave() async {
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      return false;
    }

    _formKey.currentState!.save();
    _isLoading = true;
    notifyListeners();

    try {
      // Save image locally
      final savedImagePath = await _saveImageLocally(_imageFile!);
      _user.imagePath = savedImagePath;

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').add(_user.toJson());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
