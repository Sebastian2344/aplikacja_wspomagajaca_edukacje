import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ControlButton extends PositionComponent with HasGameRef<FlameGame>, TapCallbacks{
  final VoidCallback onPressed;
  final VoidCallback onReleased;
  final Sprite sprite;
  final bool isUp;

  ControlButton({ 
    required Vector2 position,
    required this.onPressed,
    required this.onReleased,
    required this.sprite,
     this.isUp = false
  }) : super(position: position, size: Vector2(60, 40));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(SpriteComponent(
      sprite: sprite,
      size: isUp? Vector2(40,60) : size
    ));
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onPressed();
    return true;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    onReleased();
    return true;
  }
}