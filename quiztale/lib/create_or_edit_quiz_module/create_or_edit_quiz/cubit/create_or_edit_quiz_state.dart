part of 'create_or_edit_quiz_cubit.dart';

sealed class CreateOrEditQuizState extends Equatable{
  const CreateOrEditQuizState();
}

final class CreateQuizInitial extends CreateOrEditQuizState {
  const CreateQuizInitial();
  
  @override
  List<Object?> get props => [];
}
final class SuccessEdit extends CreateOrEditQuizState {
  final String text;
  
  const SuccessEdit(this.text);
  
  @override
  List<Object?> get props => [text];
}

final class SuccessCreate extends CreateOrEditQuizState {
  final String text;

  const SuccessCreate(this.text);
  
  @override
  List<Object?> get props => [text];
}

final class CreateQuizError extends CreateOrEditQuizState {
  final Exceptions error;
  
  const CreateQuizError(this.error);
  
  @override
  List<Object?> get props => [error];
}

final class DownloadedListQuizies extends CreateOrEditQuizState {
  final List<QuizModel> listQuizModel;

  const DownloadedListQuizies(this.listQuizModel);
  
  @override
  List<Object?> get props => [listQuizModel];
}

final class DownloadedSelectedQuiz extends CreateOrEditQuizState {
  final List<QuestionModel> listQuestionModel;
  final QuizModel quizModel;
  
  const DownloadedSelectedQuiz(this.listQuestionModel,this.quizModel);
  
  @override
  List<Object?> get props => [listQuestionModel,quizModel];
}
