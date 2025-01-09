// import 'package:flutter/material.dart';
// import 'package:masiha_doctor/widgets/splash/loading_animation.dart';
// import 'package:masiha_doctor/widgets/splash/logo.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();

//     Future.delayed(const Duration(seconds: 3), () {
//       // ignore: use_build_context_synchronously
//       Navigator.pushReplacementNamed(context, '/letin');
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Column(
//               children: [LogoWidget(imagepath: 'assets/images/logoo.png')],
//             ),
//             const SizedBox(height: 50),
//             LoadingAnimation(controller: _controller),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masiha_doctor/widgets/splash/loading_animation.dart';
import 'package:masiha_doctor/widgets/splash/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Check auth state and navigate accordingly
    Future.delayed(const Duration(seconds: 3), () {
      checkAuthAndNavigate();
    });
  }

  Future<void> checkAuthAndNavigate() async {
    // Get current user
    User? user = _auth.currentUser;

    if (!mounted) return;

    if (user != null) {
      // User is logged in, navigate to home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // No user logged in, navigate to login screen
      Navigator.pushReplacementNamed(context, '/letin');
    }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [LogoWidget(imagepath: 'assets/images/logoo.png')],
            ),
            const SizedBox(height: 50),
            LoadingAnimation(controller: _controller),
          ],
        ),
      ),
    );
  }
}
