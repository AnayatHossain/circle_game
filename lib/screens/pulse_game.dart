import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../models.dart';

typedef FinishedCallback = void Function(List<Player> players);

class PulseGame extends FlameGame with TapCallbacks {
  PulseGame({required this.config, required this.onFinished});

  final GameConfig config;
  final FinishedCallback onFinished;

  // HUD
  final activePlayerName = ValueNotifier<String>("");
  final timeLeftText = ValueNotifier<String>("00:00");

  // Round state
  late final List<Player> players;
  int playerIndex = 0;
  int roundsDoneForPlayer = 0;

  double roundTimeLeft = 0;

  late final RadarComponent radar;
  late final HotPotato potato;

  @override
  Future<void> onLoad() async {
    players = config.players;

    camera.viewfinder.anchor = Anchor.topLeft;

    radar = RadarComponent()..priority = 0;
    add(radar);

    potato = HotPotato(speedMultiplier: config.speedMultiplier)..priority = 1;
    add(potato);

    _startRound();
  }

  void _startRound() {
    activePlayerName.value = players[playerIndex].name;
    roundTimeLeft = config.roundSeconds.toDouble();
    _updateTimerText();
    potato.resetToRandom(radarCenter, radarRadius * 0.75);
  }

  void _endRound({required double points}) {
    players[playerIndex].score += points;

    roundsDoneForPlayer++;
    if (roundsDoneForPlayer >= config.roundsPerPlayer) {
      roundsDoneForPlayer = 0;
      playerIndex++;
    }

    if (playerIndex >= players.length) {
      onFinished(players);
      return;
    }

    _startRound();
  }

  Vector2 get radarCenter => radar.center;
  double get radarRadius => radar.radius;

  @override
  void update(double dt) {
    super.update(dt);

    if (roundTimeLeft > 0) {
      roundTimeLeft -= dt;
      if (roundTimeLeft < 0) roundTimeLeft = 0;
      _updateTimerText();

      if (roundTimeLeft == 0) {
        _endRound(points: 0);
      }
    }
  }

  void _updateTimerText() {
    final s = roundTimeLeft.ceil();
    timeLeftText.value = "00:${s.toString().padLeft(2, '0')}";
  }

  @override
  void onTapDown(TapDownEvent event) {
    // In modern Flame, use canvasPosition/localPosition (game coordinates)
    final tap = event.canvasPosition;

    final dCenter = tap.distanceTo(radarCenter);
    final dPotato = tap.distanceTo(potato.position);

    final centerHit = dCenter <= radarRadius * 0.18;
    final potatoHit = dPotato <= potato.radius * 1.4;

    double points = 0;

    if (potatoHit) points += 60;
    if (centerHit) points += 40;

    points += max(0, roundTimeLeft) * 2;

    if (!potatoHit && !centerHit) points = 5;

    _endRound(points: points);
  }
}

class RadarComponent extends PositionComponent with HasGameRef<PulseGame> {
  Vector2 _center = Vector2.zero();
  double _radius = 0;

  Vector2 get center => _center;
  double get radius => _radius;

  @override
  Future<void> onLoad() async {
    _recalc();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _recalc();
  }

  void _recalc() {
    size = gameRef.size;
    position = Vector2.zero();
    _center = Vector2(size.x / 2, size.y / 2);
    _radius = min(size.x, size.y) * 0.33;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF2A5C28);

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF7CFF6B).withOpacity(0.55);

    for (int i = 1; i <= 5; i++) {
      final r = _radius * (i / 5);
      canvas.drawCircle(_center.toOffset(), r, i == 5 ? glow : paint);
    }

    final dot = Paint()..color = const Color(0xFF7CFF6B).withOpacity(0.8);
    canvas.drawCircle(_center.toOffset(), _radius * 0.03, dot);
  }
}

class HotPotato extends PositionComponent with HasGameRef<PulseGame> {
  HotPotato({required this.speedMultiplier});

  final double speedMultiplier;
  final Random rng = Random();

  Vector2 velocity = Vector2.zero();
  double radius = 16;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    radius = 16;
    position = Vector2.zero();
    _randomVelocity();
  }

  void resetToRandom(Vector2 center, double maxR) {
    final ang = rng.nextDouble() * pi * 2;
    final r = rng.nextDouble() * maxR;
    position = center + Vector2(cos(ang), sin(ang)) * r;
    _randomVelocity();
  }

  void _randomVelocity() {
    final ang = rng.nextDouble() * pi * 2;
    final speed = (80 + rng.nextDouble() * 80) * speedMultiplier;
    velocity = Vector2(cos(ang), sin(ang)) * speed;
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * dt;

    final w = gameRef.size.x;
    final h = gameRef.size.y;

    if (position.x < radius || position.x > w - radius) {
      velocity.x *= -1;
      position.x = position.x.clamp(radius, w - radius);
    }
    if (position.y < radius || position.y > h - radius) {
      velocity.y *= -1;
      position.y = position.y.clamp(radius, h - radius);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final fill = Paint()..color = const Color(0xFFB6FF4B);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = const Color(0xFF7CFF6B).withOpacity(0.35);

    canvas.drawCircle(Offset.zero, radius, fill);
    canvas.drawCircle(Offset.zero, radius + 4, glow);
  }
}
