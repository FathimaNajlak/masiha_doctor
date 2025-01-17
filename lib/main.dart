import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:masiha_doctor/firebase_options.dart';
import 'package:masiha_doctor/providers/doc_details_provider.dart';
import 'package:masiha_doctor/providers/doctor_profile_provider.dart';
import 'package:masiha_doctor/screens/add_details.dart';

import 'package:masiha_doctor/screens/doctor/details.dart';
import 'package:masiha_doctor/screens/home/home.dart';
import 'package:masiha_doctor/screens/login_signup/all_set.dart';
import 'package:masiha_doctor/screens/login_signup/forgot_pass_screen.dart';
import 'package:masiha_doctor/screens/login_signup/let_in.dart';
import 'package:masiha_doctor/screens/login_signup/login_screen.dart';
import 'package:masiha_doctor/screens/login_signup/signup_screen.dart';
import 'package:masiha_doctor/screens/splash_screen.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DoctorDetailsProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProfileProvider()),
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/letin': (context) => const LetinPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => const SignUpPage(),
        '/allset': (context) => const AllSetScreen(),
        '/forgotpass': (context) => const ForgotPasswordScreen(),
        '/addDetails': (context) => const DoctorDetailsPage(),
        '/doctor-profile-setup': (context) => const DoctorProfileSetupScreen(),
        //'/availability-setup': (context) => const AvailabilitySetupScreen(),
        //'/consultation-fee-setup': (context) =>
        //    const ConsultationFeeSetupScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
