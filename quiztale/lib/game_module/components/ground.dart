import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends SpriteComponent {
  Ground({required this.groundSize, required this.groundPosition,required this.groundSprite});
  final Vector2 groundSize;
  final Vector2 groundPosition;
  final Sprite groundSprite;
  late final Vector2 groundHitboxVector;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = groundSprite;
    position = groundPosition;
    size = groundSize;
    groundHitboxVector = Vector2(size.x, size.y / 2);
    add(RectangleHitbox(size:groundHitboxVector));
  }
}