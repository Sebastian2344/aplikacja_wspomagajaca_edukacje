import 'package:flame/components.dart';

import '../../../../components/platform.dart';
import '../../../commons/main_component/my_platformer_game.dart';
import 'question_mark.dart';

class BaseLevel extends Component with HasGameRef<PlatformerGame>{
  final int level;

  BaseLevel(this.level);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final platform = await Sprite.load('platforma.png');

    switch (level) {
      case 1:
        
        add(Platform(
            size: Vector2(gameRef.size.x / 10, 20),
            position: Vector2(gameRef.size.x - gameRef.size.x * 0.95, gameRef.size.y - gameRef.size.y * 0.5),
            sprite: platform));
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.8, gameRef.size.y - gameRef.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.65, gameRef.size.y - gameRef.size.y * 0.25),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.45, gameRef.size.y - gameRef.size.y * 0.5),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.25, gameRef.size.y - gameRef.size.y * 0.4),
              sprite: platform),
        );

        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.95, gameRef.size.y - gameRef.size.y * 0.5 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.8, gameRef.size.y - gameRef.size.y * 0.45 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.65, gameRef.size.y - gameRef.size.y * 0.25 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.45, gameRef.size.y - gameRef.size.y * 0.5 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.25, gameRef.size.y - gameRef.size.y * 0.4 - gameRef.size.x / 20),
        ));
        break;
      case 2:

        add(Platform(
            size: Vector2(gameRef.size.x / 10, 20),
            position: Vector2(gameRef.size.x - gameRef.size.x * 0.9, gameRef.size.y - gameRef.size.y * 0.5),
            sprite: platform));
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.75, gameRef.size.y - gameRef.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.45, gameRef.size.y - gameRef.size.y * 0.25),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.30, gameRef.size.y - gameRef.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.15, gameRef.size.y - gameRef.size.y * 0.4),
              sprite: platform),
        );

        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.9, gameRef.size.y - gameRef.size.y * 0.5 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.75, gameRef.size.y - gameRef.size.y * 0.45 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.45, gameRef.size.y - gameRef.size.y * 0.25 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.30, gameRef.size.y - gameRef.size.y * 0.45 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.15, gameRef.size.y - gameRef.size.y * 0.4 - gameRef.size.x / 20),
        ));
        break;
      case 3:

        add(Platform(
            size: Vector2(gameRef.size.x / 10, 20),
            position: Vector2(gameRef.size.x - gameRef.size.x * 0.85, gameRef.size.y - gameRef.size.y * 0.25),
            sprite: platform));
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.70, gameRef.size.y - gameRef.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.55, gameRef.size.y - gameRef.size.y * 0.40),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.40, gameRef.size.y - gameRef.size.y * 0.5),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.25, gameRef.size.y - gameRef.size.y * 0.25),
              sprite: platform),
        );

        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.85, gameRef.size.y - gameRef.size.y * 0.25 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.7, gameRef.size.y - gameRef.size.y * 0.45 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.55, gameRef.size.y - gameRef.size.y * 0.40 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.40, gameRef.size.y - gameRef.size.y * 0.5 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.25, gameRef.size.y - gameRef.size.y * 0.25 - gameRef.size.x / 20),
        ));
        break;
      case 4:

       add(Platform(
            size: Vector2(gameRef.size.x / 10, 20),
            position: Vector2(gameRef.size.x - gameRef.size.x * 0.95, gameRef.size.y - gameRef.size.y * 0.5),
            sprite: platform));
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.8, gameRef.size.y - gameRef.size.y * 0.45),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.65, gameRef.size.y - gameRef.size.y * 0.25),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.45, gameRef.size.y - gameRef.size.y * 0.5),
              sprite: platform),
        );
        add(
          Platform(
              size: Vector2(gameRef.size.x / 10, 20),
              position: Vector2(gameRef.size.x - gameRef.size.x * 0.25, gameRef.size.y - gameRef.size.y * 0.4),
              sprite: platform),
        );

        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.95, gameRef.size.y - gameRef.size.y * 0.5 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.8, gameRef.size.y - gameRef.size.y * 0.45 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.65, gameRef.size.y - gameRef.size.y * 0.25 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.45, gameRef.size.y - gameRef.size.y * 0.5 - gameRef.size.x / 20),
        ));
        add(QuestionMark(
          questionMarkposition: Vector2(gameRef.size.x - gameRef.size.x * 0.25, gameRef.size.y - gameRef.size.y * 0.4 - gameRef.size.x / 20),
        ));
        break;
      default:
    }
  }
}
