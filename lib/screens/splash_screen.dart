import 'package:flutter/material.dart';
import 'setup_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06130A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PULSE\nTEST',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: Color(0xFF7CFF6B),
                  shadows: [Shadow(blurRadius: 20, color: Color(0xAA7CFF6B))],
                ),
              ),
              const SizedBox(height: 36),
              _NeonButton(
                label: 'PLAY',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SetupScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeonButton extends StatelessWidget {
  const _NeonButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF7CFF6B), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0x447CFF6B), blurRadius: 18, spreadRadius: 1),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF7CFF6B),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
