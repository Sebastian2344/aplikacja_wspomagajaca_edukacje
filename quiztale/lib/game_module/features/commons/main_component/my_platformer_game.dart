import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import '../../../components/back_to_menu.dart';
import '../../../components/background.dart';
import '../../../components/control_button.dart';
import '../../../components/ground.dart';
import '../../level_menage/cubit/level_cubit.dart';
import '../../level_menage/presentation/components/pause_button.dart';
import '../../../components/player.dart';
import '../../level_menage/presentation/components/base_level.dart';
import '../../level_menage/presentation/components/show_level.dart';
import '../../quiz_menage/cubit/quiz_part_game_cubit.dart';
import '../../quiz_menage/presentation/components/points.dart';

class PlatformerGame extends FlameGame
    with HasGameRef<FlameGame>, HasCollisionDetection {
  PlatformerGame(this._cubit, this.levelsMenagmentCubit);
  final QuizPartGameCubit _cubit;
  final LevelsMenagmentCubit levelsMenagmentCubit;
  late BaseLevel _baseLevel;
  late Player _player;

  StreamSubscription? _cubitState;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final spriteSheetRightRun = await Sprite.load('ide_w_prawo.png');
    final spriteSheetLeftRun = await Sprite.load('ide_w_lewo.png');
    final arrowLeft = await Sprite.load('arrow_left.png');
    final arrowRight = await Sprite.load('arrow_right.png');
    final arrowUp = await Sprite.load('arrow_up.png');
    final pauseButton = await Sprite.load('pause.png');
    final ground = await Sprite.load('trawa.png');
    final background = await Sprite.load('niebo.png');
    final buttonBack = await Sprite.load('back_to_menu.png');

    add(Background(bsize: size, bsprite: background));

    add(Ground(
        groundSize: Vector2(size.x, 60),
        groundPosition: Vector2(0, size.y - 60),
        groundSprite: ground));

    add(Points(
        pointsSize: Vector2(100, 50),
        pointsPosition: Vector2(size.x * 0.6, size.y / 8),
        cubit: _cubit));

    add(ShowLevel(
        showLevelPositoin: Vector2(size.x * 0.4, size.y / 8),
        showLevelSize: Vector2(100, 50),
        cubit: levelsMenagmentCubit));

    _player = Player(
      spriteSheetLeftRun: spriteSheetLeftRun,
      spriteSheetRightRun: spriteSheetRightRun,
      jumpSpeed: size.y * 1.5,
      moveSpeed: size.x / 4,
      playerSize: Vector2(size.x / 15, size.y / 5),
    );
    add(_player);

    add(ControlButton(
      position: Vector2(size.x - size.x * 0.95, size.y - 50),
      onPressed: () => _player.moveLeft(),
      onReleased: () => _player.stopMoving(),
      sprite: arrowLeft,
    ));

    add(ControlButton(
      position: Vector2(size.x - size.x * 0.8, size.y - 50),
      onPressed: () => _player.moveRight(),
      onReleased: () => _player.stopMoving(),
      sprite: arrowRight,
    ));

    add(ControlButton(
      position: Vector2(size.x - size.x * 0.1, size.y - 75),
      onPressed: () => _player.jump(),
      isUp: true,
      onReleased: (){},
      sprite: arrowUp,
    ));

    add(PauseButton(
        mySprite: pauseButton,
        position: Vector2(size.x - 50, 10),
        levelsMenagmentCubit: levelsMenagmentCubit));

    add(BackToMenu(Vector2(20, 10), buttonBack));

    _cubitState = levelsMenagmentCubit.stream.listen(
      (state) async {
        if (state.currentLevel <= state.finalLevel && state.isEndGame == false) {
          if (state.isLevelCompleted == true) {
            remove(_baseLevel);
            levelsMenagmentCubit.nextLevel();
          } else if (state.isLevelCompleted == false &&
              state.isPreparedLevel == false) {
            overlays.add('level${state.currentLevel}Story');
            _player.position = Vector2(gameRef.size.x * 0.1, gameRef.size.y - 100);
            _baseLevel = BaseLevel(state.currentLevel);
            add(_baseLevel);
            levelsMenagmentCubit.preparedLevel();
          }
        } else if (state.isEndGame == true) {
          remove(_baseLevel);
          overlays.add('gameOver');
        }
        if (state.isPausedGame == true) {
          if (overlays.isActive('pauseMenu') == false) {
            overlays.add('pauseMenu');
            paused = true;
          }
        }
        if (state.isPausedGame == false) {
          if (overlays.isActive('pauseMenu')) {
            overlays.remove('pauseMenu');
            paused = false;
          }
        }
      },
    );
  }

  void togglePause() {
    if (game.overlays.isActive('pauseMenu')) {
      game.overlays.remove('pauseMenu');
      game.paused = false;
    } else {
      game.overlays.add('pauseMenu');
      game.paused = true;
    }
  }

  @override
  void update(double dt) {
    levelsMenagmentCubit.isCompleteLevel();
    super.update(dt);
  }

  @override
  void onDispose() {
    _cubitState?.cancel();
    super.onDispose();
  }
}
