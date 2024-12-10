import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvailabilitySetupScreen extends StatefulWidget {
  const AvailabilitySetupScreen({super.key});

  @override
  State<AvailabilitySetupScreen> createState() =>
      _AvailabilitySetupScreenState();
}

class _AvailabilitySetupScreenState extends State<AvailabilitySetupScreen> {
  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  Map<String, bool> _selectedDays = {};
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var day in _weekDays) {
      _selectedDays[day] = false;
    }
    _loadExistingAvailability();
  }

  Future<void> _loadExistingAvailability() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data['availability'] != null) {
            setState(() {
              _selectedDays =
                  Map<String, bool>.from(data['availability']['days']);
              if (data['availability']['startTime'] != null) {
                _startTime = TimeOfDay(
                  hour: data['availability']['startTime']['hour'],
                  minute: data['availability']['startTime']['minute'],
                );
              }
              if (data['availability']['endTime'] != null) {
                _endTime = TimeOfDay(
                  hour: data['availability']['endTime']['hour'],
                  minute: data['availability']['endTime']['minute'],
                );
              }
            });
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading availability: $e')),
      );
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? _startTime ?? TimeOfDay.now()
          : _endTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _saveAvailability() async {
    if (!_selectedDays.containsValue(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day')),
      );
      return;
    }

    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set both start and end times')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(user.uid)
            .update({
          'availability': {
            'days': _selectedDays,
            'startTime': {
              'hour': _startTime!.hour,
              'minute': _startTime!.minute,
            },
            'endTime': {
              'hour': _endTime!.hour,
              'minute': _endTime!.minute,
            },
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Availability saved successfully')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving availability: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Availability'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Available Days',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: _weekDays.map((day) {
                        return CheckboxListTile(
                          title: Text(day),
                          value: _selectedDays[day],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedDays[day] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Set Working Hours',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Start Time'),
                          subtitle:
                              Text(_startTime?.format(context) ?? 'Not set'),
                          onTap: () => _selectTime(context, true),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('End Time'),
                          subtitle:
                              Text(_endTime?.format(context) ?? 'Not set'),
                          onTap: () => _selectTime(context, false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveAvailability,
                      child: const Text('Save Availability'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
