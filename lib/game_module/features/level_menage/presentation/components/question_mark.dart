import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../components/player.dart';
import '../../../commons/main_component/my_platformer_game.dart';

class QuestionMark extends PositionComponent with HasGameRef<PlatformerGame>,CollisionCallbacks{
  QuestionMark({
    required this.questionMarkposition
  });
  final Vector2 questionMarkposition;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.size.x  / 20, game.size.x  / 20);
    position = questionMarkposition;
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.yellow,
    ));
    add(TextComponent(
      text: '?',
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.black, fontSize: 24)),
    ));
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if(other is Player){
      gameRef.pauseEngine();
      gameRef.overlays.add('quizQuestion');
      removeFromParent();
      gameRef.levelsMenagmentCubit.collectQuestionBox();
    }
  }
}