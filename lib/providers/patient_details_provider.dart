import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class PatientDetailsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _appointmentDetails;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get appointmentDetails => _appointmentDetails;

  Future<void> fetchPatientDetails(String appointmentId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final appointmentDoc =
          await _firestore.collection('appointments').doc(appointmentId).get();

      if (!appointmentDoc.exists) {
        throw Exception('Appointment not found');
      }

      _appointmentDetails = appointmentDoc.data();
    } catch (e) {
      _error = 'Failed to fetch patient details: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
