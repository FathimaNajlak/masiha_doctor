import 'package:flutter/material.dart';
import 'package:masiha_doctor/consts/colors.dart';
import 'package:masiha_doctor/providers/doctor_details.dart';
import 'package:provider/provider.dart';

class AvailableDays extends StatelessWidget {
  const AvailableDays({super.key});

  @override
  Widget build(BuildContext context) {
    return availableDays();
  }

  Widget availableDays() {
    final days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Days',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Consumer<DoctorProfileModel>(
          builder: (context, model, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: days.map((day) {
                final isSelected = model.availableDays.contains(day);
                return GestureDetector(
                  onTap: () => model.toggleDay(day),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: isSelected
                        ? AppColors.darkcolor
                        : const Color.fromARGB(255, 211, 218, 223),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
