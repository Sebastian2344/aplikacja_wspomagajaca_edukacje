part of 'quiz_part_game_cubit.dart';

sealed class QuizPartGameState extends Equatable {
  const QuizPartGameState();

  @override
  List<Object> get props => [];
}

final class QuizPartGameInitial extends QuizPartGameState {}

final class AnsweringIsReadyToUse extends QuizPartGameState {
  const AnsweringIsReadyToUse(this.questionModelGame);
  final QuestionModelGame questionModelGame;

   @override
  List<Object> get props => [questionModelGame];
}

final class CheckedAnswer extends QuizPartGameState {
   const CheckedAnswer(this.questionModelGame,this.color, this.color2, this.color3, this.color4);
   final QuestionModelGame questionModelGame;
   final Color color;
   final Color color2;
   final Color color3;
   final Color color4;

    @override
  List<Object> get props => [questionModelGame,color,color2,color3,color4];
}
