// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:masiha_doctor/consts/colors.dart';
// import 'package:masiha_doctor/models/doctor_model.dart';
// import 'package:masiha_doctor/screens/home/main_screen_view.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool _isLoading = true;
//   RequestStatus _requestStatus = RequestStatus.pending;
//   String? _doctorId;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _checkRequestStatus();
//   }

//   Future<void> _checkRequestStatus() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         print('No user logged in');
//         Navigator.pushReplacementNamed(context, '/login');
//         return;
//       }

//       print('Checking status for user: ${user.uid}');

//       // Listen to real-time updates
//       FirebaseFirestore.instance
//           .collection('doctorRequests')
//           .where('userId', isEqualTo: user.uid)
//           // Add ordering to get the most recent request first
//           .orderBy('submittedAt', descending: true)
//           // Limit to 1 to get only the most recent request
//           .limit(1)
//           .snapshots()
//           .listen(
//         (snapshot) {
//           print('Received snapshot with ${snapshot.docs.length} documents');

//           if (snapshot.docs.isNotEmpty) {
//             final requestData = snapshot.docs.first.data();
//             final String statusString =
//                 requestData['requestStatus'] ?? 'pending';
//             print('Raw status from Firestore: $statusString');

//             RequestStatus status;
//             switch (statusString.toLowerCase()) {
//               case 'approved':
//                 status = RequestStatus.approved;
//                 break;
//               case 'rejected':
//                 status = RequestStatus.rejected;
//                 break;
//               default:
//                 status = RequestStatus.pending;
//             }

//             print('Converted to enum: $status');

//             if (mounted) {
//               setState(() {
//                 _requestStatus = status;
//                 _doctorId = snapshot.docs.first.id;
//                 _isLoading = false;
//                 _error = null;
//               });
//             }
//           } else {
//             print('No doctor request found for user ${user.uid}');
//             if (mounted) {
//               setState(() {
//                 _isLoading = false;
//                 _error = 'No request found. Please submit your details.';
//               });
//             }
//           }
//         },
//         onError: (error) {
//           print('Error in snapshot listener: $error');
//           if (mounted) {
//             setState(() {
//               _isLoading = false;
//               _error = 'Error checking request status: $error';
//             });
//           }
//         },
//       );
//     } catch (e) {
//       print('Exception in _checkRequestStatus: $e');
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _error = 'Error: $e';
//         });
//       }
//     }
//   }

//   Widget _buildErrorView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.error_outline,
//             size: 64,
//             color: Colors.red,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _error ?? 'An error occurred',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () => _checkRequestStatus(),
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPendingView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.pending_actions,
//             size: 64,
//             color: Colors.orange,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Your request is under review',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Please wait while we verify your details. This may take 24-48 hours.',
//             style: TextStyle(color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () => _showLogoutDialog(context),
//             child: const Text('Sign Out'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRejectedView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.error_outline,
//             size: 64,
//             color: Colors.red,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Your request was not approved',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Please contact support for more information.',
//             style: TextStyle(color: Colors.grey),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () => _showLogoutDialog(context),
//             child: const Text('Sign Out'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Move _buildStyledButton inside the class and fix its signature
//   Widget _buildStyledButton({
//     required String text,
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.darkcolor,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 5,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 20),
//           const SizedBox(width: 10),
//           Text(
//             text,
//             style: GoogleFonts.openSans(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildApprovedView() {
//     return const MainScreenView(); // Simply return the MainScreenView
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Doctor Dashboard'),
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(Icons.logout),
//         //     onPressed: () => _showLogoutDialog(context),
//         //   ),
//         // ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//               ? _buildErrorView()
//               : _requestStatus == RequestStatus.pending
//                   ? _buildPendingView()
//                   : _requestStatus == RequestStatus.rejected
//                       ? _buildRejectedView()
//                       : _buildApprovedView(),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout Confirmation'),
//           content: const Text('Are you sure you want to log out?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('No'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 await GoogleSignIn().signOut();
//                 Navigator.pushReplacementNamed(context, '/letin');
//               },
//               child: const Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masiha_doctor/consts/colors.dart';
import 'package:masiha_doctor/screens/home/main_screen_view.dart';
import 'package:masiha_doctor/screens/home/views/error_view.dart';
import 'package:masiha_doctor/screens/home/views/pending_view.dart';
import 'package:masiha_doctor/screens/home/views/rejected_view.dart';

enum RequestStatus { pending, approved, rejected }

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
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      FirebaseFirestore.instance
          .collection('doctorRequests')
          .where('userId', isEqualTo: user.uid)
          .orderBy('submittedAt', descending: true)
          .limit(1)
          .snapshots()
          .listen(
        (snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final requestData = snapshot.docs.first.data();
            final String statusString =
                requestData['requestStatus'] ?? 'pending';

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

            if (mounted) {
              setState(() {
                _requestStatus = status;
                _doctorId = snapshot.docs.first.id;
                _isLoading = false;
                _error = null;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _error = 'No request found. Please submit your details.';
              });
            }
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _error = 'Error checking request status: $error';
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Error: $e';
        });
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.pushReplacementNamed(context, '/letin');
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(
                  errorMessage: _error!,
                  onRetry: _checkRequestStatus,
                )
              : _requestStatus == RequestStatus.pending
                  ? PendingView(onLogout: () => _showLogoutDialog(context))
                  : _requestStatus == RequestStatus.rejected
                      ? RejectedView(onLogout: () => _showLogoutDialog(context))
                      : const MainScreenView(),
    );
  }
}
