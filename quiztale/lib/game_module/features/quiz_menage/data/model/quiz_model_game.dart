import 'question_model_game.dart';

class QuizModelGame{
  const QuizModelGame({required this.questionModelGame,});
  final List<QuestionModelGame> questionModelGame;

  factory QuizModelGame.fromJson(Map<String, dynamic> map,String source) {
    return QuizModelGame(questionModelGame: List<QuestionModelGame>.from(
        (map[source] as List).map(
          (questionMap) => QuestionModelGame.fromJson(questionMap as Map<String, dynamic>),
        ),
      ),);
  }
}