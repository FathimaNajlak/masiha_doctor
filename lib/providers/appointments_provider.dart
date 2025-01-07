import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorAppointmentsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showUpcoming = true;
  bool _isLoading = false;
  String? _error;

  bool get showUpcoming => _showUpcoming;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void toggleView(bool showUpcoming) {
    _showUpcoming = showUpcoming;
    notifyListeners();
  }

  Stream<QuerySnapshot> getAppointments() {
    final doctorId = _auth.currentUser?.uid;
    if (doctorId == null) {
      throw Exception('Doctor not authenticated');
    }

    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: _showUpcoming ? 'scheduled' : 'completed')
        .where('payment.status', isEqualTo: 'completed')
        .orderBy('appointmentDate')
        .snapshots()
        .handleError((error) {
      print('Error in stream: $error');
      _error = 'Failed to fetch appointments: $error';
      notifyListeners();
      throw error;
    });
  }

  Future<void> updateAppointmentStatus(
      String appointmentId, String status) async {
    if (_isLoading) return;

    try {
      _setLoading(true);

      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _error = 'Failed to update appointment status: $e';
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
