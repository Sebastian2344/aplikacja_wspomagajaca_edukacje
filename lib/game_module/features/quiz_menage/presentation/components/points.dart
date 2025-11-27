import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../cubit/quiz_part_game_cubit.dart';

class Points extends PositionComponent {
  Points({
    required this.pointsSize,
    required this.pointsPosition,
    required this.cubit,
  });

  int points = 0;
  final Vector2 pointsSize;
  final Vector2 pointsPosition;
  final QuizPartGameCubit cubit;
  late TextComponent pointsText;

  @override
  FutureOr<void> onLoad() {
    pointsText = TextComponent(
      position: Vector2(pointsSize.x / 2, pointsSize.y / 2),
      anchor: Anchor.center,
      text: 'Punkty: $points',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.green[900],
          fontSize: 20,
        ),
      ),
    );

    add(
      RectangleComponent(
        paint: Paint()..color = Colors.transparent,
        size: pointsSize,
        position: pointsPosition,
        anchor: Anchor.center,
        children: [pointsText],
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (points != cubit.points) {
      points = cubit.points;
      pointsText.text = 'Punkty: $points';
    }
  }
}