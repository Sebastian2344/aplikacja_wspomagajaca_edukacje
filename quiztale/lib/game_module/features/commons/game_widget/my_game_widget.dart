import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../overlays/exit_overlay.dart';
import '../../../overlays/game_over.dart';
import '../../../overlays/level_1_story.dart';
import '../../../overlays/level_2_story.dart';
import '../../../overlays/level_3_story.dart';
import '../../../overlays/level_4_story.dart';
import '../../level_menage/cubit/level_cubit.dart';
import '../../level_menage/presentation/overlays/pause_menu.dart';
import '../../quiz_menage/cubit/quiz_part_game_cubit.dart';
import '../../quiz_menage/presentation/overlays/question.dart';
import '../main_component/my_platformer_game.dart';

class MyGameWidget extends StatelessWidget {
  const MyGameWidget({super.key, required this.quizPartGameCubit, required this.levelsMenagmentCubit});
  final QuizPartGameCubit quizPartGameCubit;
  final LevelsMenagmentCubit levelsMenagmentCubit;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GameWidget(
        game: PlatformerGame(quizPartGameCubit, levelsMenagmentCubit),
        overlayBuilderMap: {
          'pauseMenu': (BuildContext context, PlatformerGame game) {
            return PauseMenu(game: game);
          },
          'quizQuestion': (BuildContext context, PlatformerGame game) {
            return Question(game: game);
          },
          'level1Story': (BuildContext context, PlatformerGame game) {
            return Level1Story(game: game);
          },
          'level2Story': (BuildContext context, PlatformerGame game) {
            return Level2Story(game: game);
          },
          'level3Story': (BuildContext context, PlatformerGame game) {
            return Level3Story(game: game);
          },
          'level4Story': (BuildContext context, PlatformerGame game) {
            return Level4Story(game: game);
          },
          'gameOver': (BuildContext context, PlatformerGame game) {
            return GameOver(game: game);
          },
          'exitOverlay': (BuildContext context, PlatformerGame game) {
            return ExitOverlay(game: game);
          }
        },
      ),
    );
  }
}
