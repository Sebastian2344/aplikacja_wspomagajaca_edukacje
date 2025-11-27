import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../cubit/level_cubit.dart';

class ShowLevel extends PositionComponent {
  ShowLevel({
    required this.showLevelPositoin,
    required this.showLevelSize,
    required this.cubit,
  });

  int level = 0;
  final Vector2 showLevelPositoin;
  final Vector2 showLevelSize;
  final LevelsMenagmentCubit cubit;
  late final TextComponent levelText;

  @override
  FutureOr<void> onLoad() {
    levelText = TextComponent(
      position: Vector2(showLevelSize.x / 2, showLevelSize.y / 2),
      anchor: Anchor.center,
      text: 'Poziom: $level',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.green[900],
          fontSize: 20,
        ),
      ),
    );

    add(RectangleComponent(
      paint: Paint()..color = Colors.transparent,
      size: showLevelSize,
      position: showLevelPositoin,
      anchor: Anchor.center,
      children: [levelText],
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (level != cubit.state.currentLevel) {
      level = cubit.state.currentLevel;
      levelText.text = 'Poziom: ${cubit.state.currentLevel}';
    }
  }
}
