import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'ground.dart';
import 'platform.dart';


enum Action { leftStand, rightStand, runLeft, runRight }

class Player extends SpriteAnimationComponent
    with HasGameRef<FlameGame>, CollisionCallbacks {
  final double moveSpeed;
  final double jumpSpeed;
  final Vector2 playerSize;
  final Sprite spriteSheetLeftRun;
  final Sprite spriteSheetRightRun;

  Vector2 velocity = Vector2.zero();
  bool isJumping = false;

  Enum action = Action.rightStand;
  late SpriteAnimation leftAnimationRun;
  late SpriteAnimation rightAnimationRun;
  late SpriteAnimation rightAnimationStand;
  late SpriteAnimation leftAnimationStand;

  Player(
      {required this.spriteSheetLeftRun,
      required this.spriteSheetRightRun,
      required this.jumpSpeed,
      required this.moveSpeed,
      required this.playerSize}) {
    anchor = Anchor.center;
    size = playerSize;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    leftAnimationRun = SpriteAnimation.fromFrameData(
      spriteSheetLeftRun.image,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(200, 200),
        stepTime: 0.1,
      ),
    );

    rightAnimationRun = SpriteAnimation.fromFrameData(
      spriteSheetRightRun.image,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(200, 200),
        stepTime: 0.1,
      ),
    );

    leftAnimationStand = SpriteAnimation.fromFrameData(
      spriteSheetLeftRun.image,
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(200, 200),
        stepTime: 0.1,
      ),
    );

    rightAnimationStand = SpriteAnimation.fromFrameData(
      spriteSheetRightRun.image,
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(200, 200),
        stepTime: 0.1,
      ),
    );

    animation = rightAnimationStand;

    position =
        Vector2(gameRef.size.x / 10, gameRef.size.y - gameRef.size.y * 0.2);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    velocity.y += 20;
    if (position.x - size.x > 0 && position.x + size.x < gameRef.size.x) {
    } else {
      stopMoving();
    }

    switch (action) {
      case Action.runLeft:
        animation = leftAnimationRun;
        break;
      case Action.runRight:
        animation = rightAnimationRun;
        break;
      case Action.leftStand:
        animation = leftAnimationStand;
        break;
      case Action.rightStand:
        animation = rightAnimationStand;
        break;
      default:
    }
  }

  void moveLeft() {
    velocity.x = -moveSpeed;
    action = Action.runLeft;
  }

  void moveRight() {
    velocity.x = moveSpeed;
    action = Action.runRight;
  }

  void stopMoving() {
    velocity.x = 0;
    if (action == Action.runLeft) {
      action = Action.leftStand;
    } else if (action == Action.runRight) {
      action = Action.rightStand;
    }
  }

  void jump() {
    if (!isJumping) {
      isJumping = true;
      velocity.y = -jumpSpeed;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Platform) {
      if (velocity.y >= 0 && position.y - size.y / 2 <= other.position.y) {
        position.y = other.position.y - size.y / 2;
        isJumping = false;
        velocity.y = 0;
      } else if (velocity.y < 0 &&
          position.y + size.y / 2 >= other.position.y + other.size.y) {
        position.y = other.position.y + other.size.y + size.y / 2;
        velocity.y = jumpSpeed;
      }
    } else if (other is Ground) {
      if (position.y >=
          gameRef.size.y - other.groundHitboxVector.y - size.y / 2) {
        position.y = gameRef.size.y - other.groundHitboxVector.y - size.y / 2;
        isJumping = false;
        velocity.y = 0;
      }
    }
  }
}
