import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PulseTestApp());
}

class PulseTestApp extends StatelessWidget {
  const PulseTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
