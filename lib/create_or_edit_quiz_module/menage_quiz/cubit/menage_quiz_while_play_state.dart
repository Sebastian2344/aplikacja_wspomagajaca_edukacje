part of 'menage_quiz_while_play_cubit.dart';

sealed class MenageQuizState extends Equatable{
  const MenageQuizState();
}

final class MenageQuizInitial extends MenageQuizState {
  const MenageQuizInitial();
  
  @override
  List<Object?> get props => [];
}

final class MenageQuizLoading extends MenageQuizState {
  const MenageQuizLoading();
  
  @override
  List<Object?> get props => [];
}

final class MenageQuizError extends MenageQuizState {
  final Exceptions error;
 
  const MenageQuizError(this.error);
  
  @override
  List<Object?> get props => [error]; 
}

final class MenageQuizButtonsColors extends MenageQuizState {
  final MaterialColor setStart;
  final MaterialColor setPause;
  final MaterialColor setEnd;
  final MaterialColor nextQuestion;
  
  const MenageQuizButtonsColors(this.setStart,this.nextQuestion,this.setPause,this.setEnd);
  
  @override
  List<Object?> get props => [setStart,nextQuestion,setPause,setEnd];
}
