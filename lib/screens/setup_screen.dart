import 'package:flutter/material.dart';
import '../models.dart';
import 'game_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  Difficulty difficulty = Difficulty.easy;
  int playerCount = 2;
  final controllers = <TextEditingController>[
    TextEditingController(text: "Player 1"),
    TextEditingController(text: "Player 2"),
  ];

  void _syncControllers() {
    while (controllers.length < playerCount) {
      controllers.add(TextEditingController(text: "Player ${controllers.length + 1}"));
    }
    while (controllers.length > playerCount) {
      controllers.removeLast().dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    _syncControllers();

    return Scaffold(
      backgroundColor: const Color(0xFF06130A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06130A),
        title: const Text('HOT POTATO', style: TextStyle(color: Color(0xFF7CFF6B))),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _Label("SELECT MODE"),
          const SizedBox(height: 8),
          Row(
            children: Difficulty.values.map((d) {
              final selected = d == difficulty;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _Chip(
                    label: d.name.toUpperCase(),
                    selected: selected,
                    onTap: () => setState(() => difficulty = d),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),

          _Label("HOW MANY PLAYERS?"),
          const SizedBox(height: 8),
          Row(
            children: [2, 3, 4].map((n) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _Chip(
                    label: "$n",
                    selected: playerCount == n,
                    onTap: () => setState(() => playerCount = n),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),
          _Label("PLAYER NAMES"),
          const SizedBox(height: 10),
          ...List.generate(playerCount, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: controllers[i],
                style: const TextStyle(color: Color(0xFFBFFFB6)),
                decoration: InputDecoration(
                  hintText: "Player ${i + 1}",
                  hintStyle: const TextStyle(color: Color(0xFF3E7E3A)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF2A5C28)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF7CFF6B), width: 2),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 14),
          _NeonButton(
            label: "START GAME",
            onTap: () {
              final players = List.generate(playerCount, (i) {
                final name = controllers[i].text.trim().isEmpty ? "Player ${i + 1}" : controllers[i].text.trim();
                return Player(name);
              });

              final cfg = GameConfig(
                difficulty: difficulty,
                roundSeconds: 5,
                players: players,
                roundsPerPlayer: 1,
              );

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GameScreen(config: cfg)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF7CFF6B),
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF7CFF6B) : const Color(0xFF123A1E);
    final textColor = selected ? const Color(0xFF06130A) : const Color(0xFF7CFF6B);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(selected ? 0.9 : 0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A5C28)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
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
