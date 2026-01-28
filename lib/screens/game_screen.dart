import 'package:circle_game/screens/pulse_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import 'result_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.config});
  final GameConfig config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06130A),
      body: SafeArea(
        child: GameWidget<PulseGame>(
          game: PulseGame(
            config: config,
            onFinished: (players) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ResultScreen(players: players)),
              );
            },
          ),
          overlayBuilderMap: {
            'hud': (ctx, game) => _Hud(game: game),
          },
          initialActiveOverlays: const ['hud'],
        ),
      ),
    );
  }
}

class _Hud extends StatelessWidget {
  const _Hud({required this.game});
  final PulseGame game;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder(
              valueListenable: game.activePlayerName,
              builder: (_, v, __) => Text(
                v,
                style: const TextStyle(color: Color(0xFF7CFF6B), fontWeight: FontWeight.w900),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: game.timeLeftText,
              builder: (_, v, __) => Text(
                v,
                style: const TextStyle(color: Color(0xFF7CFF6B), fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
