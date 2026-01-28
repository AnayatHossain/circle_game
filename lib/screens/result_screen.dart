import 'package:flutter/material.dart';
import '../models.dart';
import 'splash_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.players});
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final sorted = [...players]..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      backgroundColor: const Color(0xFF06130A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                "CONGRATULATIONS!",
                style: TextStyle(
                  color: Color(0xFF7CFF6B),
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFF2A5C28)),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: sorted.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF2A5C28)),
                    itemBuilder: (_, i) {
                      final p = sorted[i];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${i + 1}. ${p.name}",
                            style: const TextStyle(color: Color(0xFFBFFFB6), fontWeight: FontWeight.w800),
                          ),
                          Text(
                            p.score.toStringAsFixed(1),
                            style: const TextStyle(color: Color(0xFF7CFF6B), fontWeight: FontWeight.w900),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _NeonButton(
                      label: "PLAY AGAIN",
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const SplashScreen()),
                            (_) => false,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF7CFF6B),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
