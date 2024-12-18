import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masiha_doctor/consts/colors.dart';
import 'package:masiha_doctor/models/doctor_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  RequestStatus _requestStatus = RequestStatus.pending;
  String? _doctorId;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkRequestStatus();
  }

  Future<void> _checkRequestStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      print('Checking status for user: ${user.uid}');

      // Listen to real-time updates
      FirebaseFirestore.instance
          .collection('doctorRequests')
          .where('userId', isEqualTo: user.uid)
          // Add ordering to get the most recent request first
          .orderBy('submittedAt', descending: true)
          // Limit to 1 to get only the most recent request
          .limit(1)
          .snapshots()
          .listen(
        (snapshot) {
          print('Received snapshot with ${snapshot.docs.length} documents');

          if (snapshot.docs.isNotEmpty) {
            final requestData = snapshot.docs.first.data();
            final String statusString =
                requestData['requestStatus'] ?? 'pending';
            print('Raw status from Firestore: $statusString');

            RequestStatus status;
            switch (statusString.toLowerCase()) {
              case 'approved':
                status = RequestStatus.approved;
                break;
              case 'rejected':
                status = RequestStatus.rejected;
                break;
              default:
                status = RequestStatus.pending;
            }

            print('Converted to enum: $status');

            if (mounted) {
              setState(() {
                _requestStatus = status;
                _doctorId = snapshot.docs.first.id;
                _isLoading = false;
                _error = null;
              });
            }
          } else {
            print('No doctor request found for user ${user.uid}');
            if (mounted) {
              setState(() {
                _isLoading = false;
                _error = 'No request found. Please submit your details.';
              });
            }
          }
        },
        onError: (error) {
          print('Error in snapshot listener: $error');
          if (mounted) {
            setState(() {
              _isLoading = false;
              _error = 'Error checking request status: $error';
            });
          }
        },
      );
    } catch (e) {
      print('Exception in _checkRequestStatus: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Error: $e';
        });
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $error')),
      );
    }
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            _error ?? 'An error occurred',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _checkRequestStatus(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.pending_actions,
            size: 64,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your request is under review',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please wait while we verify your details. This may take 24-48 hours.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _signOut(context),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your request was not approved',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please contact support for more information.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _signOut(context),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  // Move _buildStyledButton inside the class and fix its signature
  Widget _buildStyledButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkcolor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animated Check Icon
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 15,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          size: 120,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Welcome Text
                Text(
                  'Account Approved!',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  'Congratulations! Your professional account has been verified.',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Action Buttons
                _buildStyledButton(
                  text: 'Complete Your Profile',
                  icon: Icons.person_outline,
                  onPressed: () {
                    Navigator.pushNamed(context, '/doctor-profile-setup');
                  },
                ),

                const SizedBox(height: 16),

                // _buildStyledButton(
                //   text: 'Set Availability',
                //   icon: Icons.calendar_today,
                //   onPressed: () {
                //     Navigator.pushNamed(context, '/availability-setup');
                //   },
                // ),
                const SizedBox(height: 16),

                // _buildStyledButton(
                //   text: 'Set Consultaion fee',
                //   icon: Icons.calendar_today,
                //   onPressed: () {
                //     Navigator.pushNamed(context, '/consultation-fee-setup');
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorView()
              : _requestStatus == RequestStatus.pending
                  ? _buildPendingView()
                  : _requestStatus == RequestStatus.rejected
                      ? _buildRejectedView()
                      : _buildApprovedView(),
    );
  }
}
