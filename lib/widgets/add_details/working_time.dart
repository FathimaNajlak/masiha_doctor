import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masiha_doctor/providers/doc_details_provider.dart';

class WorkingTimeWidget extends StatelessWidget {
  final DoctorDetailsProvider provider;

  const WorkingTimeWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final startTime = provider.doctor.workingTimeStart ?? DateTime.now();
    final endTime = provider.doctor.workingTimeEnd ??
        DateTime.now().add(const Duration(hours: 8));

    String formatTime(DateTime time) {
      return DateFormat.jm().format(time);
    }

    TextEditingController startTimeController =
        TextEditingController(text: formatTime(startTime));
    TextEditingController endTimeController =
        TextEditingController(text: formatTime(endTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Working Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: startTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  hintText: 'Select start time',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final newStartTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(startTime),
                      );
                      if (newStartTime != null) {
                        final newStartDateTime = DateTime(
                          startTime.year,
                          startTime.month,
                          startTime.day,
                          newStartTime.hour,
                          newStartTime.minute,
                        );
                        provider.doctor.workingTimeStart = newStartDateTime;
                        startTimeController.text = formatTime(newStartDateTime);
                        provider.notifyListeners();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: endTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'End Time',
                  hintText: 'Select end time',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final newEndTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(endTime),
                      );
                      if (newEndTime != null) {
                        final newEndDateTime = DateTime(
                          endTime.year,
                          endTime.month,
                          endTime.day,
                          newEndTime.hour,
                          newEndTime.minute,
                        );
                        provider.doctor.workingTimeEnd = newEndDateTime;
                        endTimeController.text = formatTime(newEndDateTime);
                        provider.notifyListeners();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
