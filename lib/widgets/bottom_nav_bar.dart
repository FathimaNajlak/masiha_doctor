import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/colors.dart';
import 'package:masiha_doctor/screens/home/appointments_screen.dart';
import 'package:masiha_doctor/screens/home/profile/profile_screen.dart';
import 'package:masiha_doctor/screens/home/report_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home'); // Replace with your route
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DoctorAppointmentsScreen()),
        ); // Replace with your route
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorReportsScreen()),
        ); // Replace with your route
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorProfileScreen()),
        ); // Replace with your route
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.darkcolor,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.access_time), label: 'Schedule'),
        BottomNavigationBarItem(
            icon: Icon(Icons.trending_up), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
