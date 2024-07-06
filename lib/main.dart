import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saiflash/screens/quiz_screen.dart';
import 'package:saiflash/screens/start_screen.dart';

import 'package:saiflash/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
        bodySmall: GoogleFonts.outfit(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.outfit(
            fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.outfit(
            fontSize: 36, color: Colors.black, fontWeight: FontWeight.w700),
        labelSmall: GoogleFonts.outfit(
            fontSize: 12,
            color: const Color(0xff666666),
            fontWeight: FontWeight.w300),
        titleLarge: const TextStyle(
            fontFamily: 'Nuances',
            fontSize: 52,
            fontWeight: FontWeight.w700,
            height: 1,
            color: Colors.black),
        titleMedium: const TextStyle(
            fontFamily: 'Nuances',
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: Colors.black),
      )),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return const QuizScreen();
          }
          return const StartScreen();
        },
      ),
    );
  }
}
