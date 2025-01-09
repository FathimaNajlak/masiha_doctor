import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingReportsProvider with ChangeNotifier {
  List<MapEntry<String, int>> weeklyBookings = [];
  List<MapEntry<String, int>> monthlyBookings = [];
  double weeklyRevenue = 0;
  double monthlyRevenue = 0;
  double totalRevenue = 0;
  bool isLoading = true;
  String? error;
  double? consultationFee;
  BookingReportsProvider() {
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      isLoading = true;
      notifyListeners();
      await _fetchConsultationFee();

      // Start listening to both streams
      _subscribeToWeeklyBookings();
      _subscribeToMonthlyBookings();
      _subscribeToTotalRevenue();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchConsultationFee() async {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    if (doctorId == null) return;

    final doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    if (doctorDoc.exists) {
      consultationFee = (doctorDoc.data()?['consultationFee'] ?? 0).toDouble();
    }
  }

  void _subscribeToTotalRevenue() {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    if (doctorId == null) return;

    FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .listen(
      (snapshot) {
        totalRevenue = snapshot.docs.length * (consultationFee ?? 0);
        notifyListeners();
      },
    );
  }

  void _subscribeToWeeklyBookings() {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    if (doctorId == null) {
      error = 'Doctor not authenticated';
      isLoading = false;
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: 'completed')
        .where('appointmentDate', isGreaterThanOrEqualTo: weekStart)
        .where('appointmentDate', isLessThan: weekEnd)
        .snapshots()
        .listen(
      (snapshot) {
        final Map<String, int> dailyCounts = {};

        for (var i = 0; i < 7; i++) {
          final date = weekStart.add(Duration(days: i));
          dailyCounts[DateFormat('EEE').format(date)] = 0;
        }

        for (var doc in snapshot.docs) {
          final date = (doc.data()['appointmentDate'] as Timestamp).toDate();
          final dayName = DateFormat('EEE').format(date);
          dailyCounts[dayName] = (dailyCounts[dayName] ?? 0) + 1;
        }

        weeklyBookings = dailyCounts.entries.toList();
        isLoading = false;
        notifyListeners();
        weeklyRevenue = snapshot.docs.length * (consultationFee ?? 0);
        notifyListeners();
      },
      onError: (e) {
        error = e.toString();
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void _subscribeToMonthlyBookings() {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    if (doctorId == null) {
      error = 'Doctor not authenticated';
      isLoading = false;
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: 'completed')
        .where('appointmentDate', isGreaterThanOrEqualTo: monthStart)
        .where('appointmentDate', isLessThan: monthEnd)
        .snapshots()
        .listen(
      (snapshot) {
        final Map<String, int> dailyCounts = {};

        for (var i = 1; i <= monthEnd.day; i++) {
          dailyCounts[i.toString()] = 0;
        }

        for (var doc in snapshot.docs) {
          final date = (doc.data()['appointmentDate'] as Timestamp).toDate();
          final dayNum = date.day.toString();
          dailyCounts[dayNum] = (dailyCounts[dayNum] ?? 0) + 1;
        }

        monthlyBookings = dailyCounts.entries.toList();
        isLoading = false;
        notifyListeners();
        monthlyRevenue = snapshot.docs.length * (consultationFee ?? 0);
        notifyListeners();
      },
      onError: (e) {
        error = e.toString();
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void refresh() {
    initializeData();
  }
}
