import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:masiha_doctor/firebase_options.dart';
import 'package:masiha_doctor/providers/login_provider.dart';
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
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/letin': (context) => const LetinPage(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => SignupScreen(),
        '/allset': (context) => const AllSetScreen(),
        '/forgotpass': (context) => const ForgotPasswordScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
