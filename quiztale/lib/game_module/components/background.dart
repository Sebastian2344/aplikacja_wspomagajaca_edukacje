import 'package:flame/components.dart';

class Background extends SpriteComponent{
  Background({required this.bsize,required this.bsprite});
  final Vector2 bsize;
  final Sprite bsprite;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = bsize;
    sprite = bsprite;
  }
}