import 'package:flutter/material.dart';
import 'package:masiha_doctor/widgets/splash/loading_animation.dart';
import 'package:masiha_doctor/widgets/splash/logo.dart';

class AllSetScreen extends StatefulWidget {
  const AllSetScreen({super.key});

  @override
  State<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends State<AllSetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    // Navigate to next screen after 3 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       // builder: (context) => const DoctorProfilePage(),
        //       ),
        // );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Column(
            children: [LogoWidget(imagepath: 'assets/images/all_set.png')],
          ),
          const SizedBox(height: 24),
          const Text(
            'Congratulations 🎉',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your account is ready to use',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 50),
          LoadingAnimation(controller: _controller),
        ])));
  }
}
