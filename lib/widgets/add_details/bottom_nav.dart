import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return bottomNav();
  }

  Widget bottomNav() {
    return Container(
      height: 60, // Increase the height of the bottom navigation bar
      decoration: BoxDecoration(
        color: const Color.fromARGB(
            255, 215, 214, 214), // Set the background color of the nav bar
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -2), // Changes the shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, true),
          _buildNavItem(Icons.access_time, false),
          _buildNavItem(Icons.bar_chart, false),
          _buildNavItem(Icons.person_outline, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return Icon(
      icon,
      color: isSelected ? AppColors.darkcolor : Colors.grey,
    );
  }
}
