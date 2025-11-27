part of 'quiz_cubit.dart';

sealed class QuizState extends Equatable{
  const QuizState();
}
final class QuizInitialState extends QuizState {
   const QuizInitialState();
   
     @override
     List<Object?> get props => [];
}

final class ShowQuestion extends QuizState{
  final QuestionModel question;

  const ShowQuestion(this.question);
  
  @override
  List<Object?> get props => [question];
}

final class ShowCorrectAnswer extends QuizState{
  final QuestionModel quizModel;
  final bool isCorrect;

  const ShowCorrectAnswer(this.quizModel,this.isCorrect);
  
  @override
  List<Object?> get props => [quizModel,isCorrect]; 
}

final class ShowEndScreen extends QuizState{
  final List<SolvedQuizModel> data;

  const ShowEndScreen(this.data);
  
  @override
  List<Object?> get props => [data];
}

final class ShowPauseQuiz extends QuizState{
  const ShowPauseQuiz();

  @override
  List<Object?> get props => [];
}

final class QuizError extends QuizState{
  final Exceptions exceptions;
  final String quizId;
  final String nickname;
  final int gameCode;
  final String quizOwnerId;

  const QuizError(this.exceptions, this.quizId, this.nickname, this.gameCode, this.quizOwnerId);
  
  @override
  List<Object?> get props => [exceptions,quizId,nickname,gameCode,quizOwnerId]; 
}

final class QuizFinishError extends QuizState{
  final Exceptions exceptions;
  final String quizId;
  final String nickname;
  final String quizOwnerId;

  const QuizFinishError(this.exceptions, this.quizId, this.nickname,this.quizOwnerId);
  
  @override
  List<Object?> get props => [exceptions,quizId,nickname,quizOwnerId]; 
}