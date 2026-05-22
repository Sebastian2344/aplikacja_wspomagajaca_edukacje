import 'package:flame/components.dart';

import '../../../../components/platform.dart';
import '../../../commons/main_component/my_platformer_game.dart';
import 'question_mark.dart';

class BaseLevel extends Component with HasGameReference<PlatformerGame>{
  final int level;

  BaseLevel(this.level);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final platform = await Sprite.load('platforma.png');

    switch (level) {
      case 1:
        
        add(Platform(
            size: Vector2(game.size.x / 10, 20),
            position: Vector2(game.size.x - game.size.x * 0.95, game.size.y - game.size.y * 0.5),
            sprite: platform));
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.8, game.size.y - game.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.65, game.size.y - game.size.y * 0.25),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.45, game.size.y - game.size.y * 0.5),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.25, game.size.y - game.size.y * 0.4),
              sprite: platform),
        );

        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.95, game.size.y - game.size.y * 0.5 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.8, game.size.y - game.size.y * 0.45 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.65, game.size.y - game.size.y * 0.25 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.45, game.size.y - game.size.y * 0.5 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.25, game.size.y - game.size.y * 0.4 - game.size.x / 20),
        ));
        break;
      case 2:

        add(Platform(
            size: Vector2(game.size.x / 10, 20),
            position: Vector2(game.size.x - game.size.x * 0.9, game.size.y - game.size.y * 0.5),
            sprite: platform));
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.75, game.size.y - game.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.45, game.size.y - game.size.y * 0.25),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.30, game.size.y - game.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.15, game.size.y - game.size.y * 0.4),
              sprite: platform),
        );

        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.9, game.size.y - game.size.y * 0.5 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.75, game.size.y - game.size.y * 0.45 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.45, game.size.y - game.size.y * 0.25 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.30, game.size.y - game.size.y * 0.45 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.15, game.size.y - game.size.y * 0.4 - game.size.x / 20),
        ));
        break;
      case 3:

        add(Platform(
            size: Vector2(game.size.x / 10, 20),
            position: Vector2(game.size.x - game.size.x * 0.85, game.size.y - game.size.y * 0.25),
            sprite: platform));
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.70, game.size.y - game.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.55, game.size.y - game.size.y * 0.40),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.40, game.size.y - game.size.y * 0.5),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.25, game.size.y - game.size.y * 0.25),
              sprite: platform),
        );

        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.85, game.size.y - game.size.y * 0.25 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.7, game.size.y - game.size.y * 0.45 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.55, game.size.y - game.size.y * 0.40 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.40, game.size.y - game.size.y * 0.5 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.25, game.size.y - game.size.y * 0.25 - game.size.x / 20),
        ));
        break;
      case 4:

       add(Platform(
            size: Vector2(game.size.x / 10, 20),
            position: Vector2(game.size.x - game.size.x * 0.95, game.size.y - game.size.y * 0.5),
            sprite: platform));
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.8, game.size.y - game.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.65, game.size.y - game.size.y * 0.25),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.45, game.size.y - game.size.y * 0.5),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(game.size.x / 10, 20),
              position: Vector2(game.size.x - game.size.x * 0.25, game.size.y - game.size.y * 0.4),
              sprite: platform),
        );

        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.95, game.size.y - game.size.y * 0.5 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.8, game.size.y - game.size.y * 0.45 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.65, game.size.y - game.size.y * 0.25 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.45, game.size.y - game.size.y * 0.5 - game.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(game.size.x - game.size.x * 0.25, game.size.y - game.size.y * 0.4 - game.size.x / 20),
        ));
        break;
      default:
    }
  }
}
