import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masiha_doctor/screens/home/appointments_screen.dart';
import 'package:masiha_doctor/screens/home/profile/profile_screen.dart';
import 'package:masiha_doctor/screens/home/report_screen.dart';
import 'package:masiha_doctor/widgets/bottom_nav_bar.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome Section
                    Text(
                      'Welcome to Masiha!',
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your account has been approved',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Message Illustration
                    // Container(
                    //   height: 200,
                    //   width: 200,
                    //   decoration: BoxDecoration(
                    //     color: Colors.blue.withOpacity(0.1),
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: const Icon(
                    //     Icons.mark_email_unread_outlined,
                    //     size: 80,
                    //     color: Colors.blue,
                    //   ),
                    // ),

                    const SizedBox(height: 48),

                    // Quick Actions Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.edit_document,
                                color: Colors.blue),
                            title: Text(
                              'Complete / edit details',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/doctor-profile-setup');
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.access_time,
                                color: Colors.blue),
                            title: Text(
                              'Go to your appointments',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DoctorAppointmentsScreen()),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.trending_up,
                                color: Colors.blue),
                            title: Text(
                              'See your reports',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DoctorReportsScreen()),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.person_outline,
                                color: Colors.blue),
                            title: Text(
                              'Your Profile',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DoctorProfileScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
