import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../features/commons/main_component/my_platformer_game.dart';


class BackToMenu extends SpriteComponent with TapCallbacks,HasGameRef<PlatformerGame>{
  BackToMenu(this.buttonPosition, this.buttonSprite): super(size: Vector2(40, 40));
  final Vector2 buttonPosition;
  final Sprite buttonSprite;

  @override
  FutureOr<void> onLoad() {
    position = buttonPosition;
    sprite = buttonSprite;
    return super.onLoad();
  }
  @override
  void onTapDown(TapDownEvent event) {
    game.overlays.add('exitOverlay');
    super.onTapDown(event);
  }
}