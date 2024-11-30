import 'package:flutter/material.dart';

class DoctorProfileModel extends ChangeNotifier {
  String category = '';
  String hospitalName = '';
  String yearsOfExperience = '';
  String workingTime = '';
  String consultationFees = '';
  List<String> certificates = [];
  Set<String> availableDays = {};

  void updateCategory(String value) {
    category = value;
    notifyListeners();
  }

  void toggleDay(String day) {
    if (availableDays.contains(day)) {
      availableDays.remove(day);
    } else {
      availableDays.add(day);
    }
    notifyListeners();
  }

  void addCertificate(String certificate) {
    certificates.add(certificate);
    notifyListeners();
  }

  void save(BuildContext context) {
    print('Saving profile...');
    Navigator.pushNamed(context, '/home');
  }
}
