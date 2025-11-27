import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../cubit/level_cubit.dart';

class PauseButton extends SpriteComponent with TapCallbacks{
  final Sprite mySprite;
  final LevelsMenagmentCubit levelsMenagmentCubit;
  PauseButton({required Vector2 position,required this.mySprite,required this.levelsMenagmentCubit})
      : super(position: position, size: Vector2(40, 40));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = mySprite;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    levelsMenagmentCubit.pauseOn();
    return true;
  }
}