import 'dart:io';
import 'package:path/path.dart' as path; // For path operations
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masiha_doctor/models/doctor_model.dart';
import 'package:path_provider/path_provider.dart';

class DoctorDetailsProvider extends ChangeNotifier {
  final DoctorDetailsModel _doctor = DoctorDetailsModel();
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  DoctorDetailsModel get doctor => _doctor;
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

  Future<String> saveImageLocally(File imageFile) async {
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
      final savedImagePath = await saveImageLocally(_imageFile!);
      _doctor.imagePath = savedImagePath;

      // Save doctor details to Firestore
      await FirebaseFirestore.instance
          .collection('doctors')
          .add(_doctor.toJson());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  final List<File> _certificateFiles = [];

  List<File> get certificateFiles => _certificateFiles;

  Future<void> addEducation(Education education) async {
    _doctor.educations ??= [];
    _doctor.educations!.add(education);
    notifyListeners();
  }

  Future<void> removeEducation(int index) async {
    _doctor.educations?.removeAt(index);
    notifyListeners();
  }

  Future<void> pickCertificate(int educationIndex) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _certificateFiles.add(File(pickedFile.path));
      _doctor.educations?[educationIndex].certificatePath = pickedFile.path;
      notifyListeners();
    }
  }
}
