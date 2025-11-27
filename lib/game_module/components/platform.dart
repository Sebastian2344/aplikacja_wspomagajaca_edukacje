import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Platform extends SpriteComponent with CollisionCallbacks{
  Platform({required Vector2 size, required Vector2 position,required Sprite sprite})
      : super(size: size, position: position,sprite: sprite);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }
}