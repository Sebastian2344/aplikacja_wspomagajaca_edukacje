import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../commons/models/question_model.dart';
import '../../commons/models/quiz_model.dart';
part 'quiz_panel_state.dart';

class QuizPanelCubit extends Cubit<QuizPanelState> {
  QuizPanelCubit() : super(const QuizPanelState());

  int _indexQuestion = -1;
  bool _editQuestion = false;

  void updateIndex(int value) {
    emit(state.copyWith(currentIndex: value));
  }

  bool isEdit() {
    return _editQuestion;
  }

  bool codeIsNotInitVal() {
    return state.gameCode == 0;
  }

 void loadDataToState(
    List<QuestionModel> listQuestionModel, QuizModel quizModel) {
    emit(state.copyWith(
    questions: listQuestionModel,
      quizTitle: quizModel.quizTitle,
    gameCode: quizModel.gameCode));
  }

  void updateQuestionText(String text) {
    emit(state.copyWith(questionText: text));
  }

  void updateAnswerText(int index, String text) {
    final updatedAnswers = [...state.answerTexts];
    updatedAnswers[index] = text;
    emit(state.copyWith(answerTexts: updatedAnswers));
  }

  void updateCorrectAnswer(int correctIndex) {
    if(state.answerTexts.isNotEmpty){
      emit(state.copyWith(correctAnswer: state.answerTexts[correctIndex]));
    }
  }

  void updatePoints(String setpoints) {
    int points = int.tryParse(setpoints) ?? state.points;
    emit(state.copyWith(points: points));
  }

  void updateTimeLimit(String setTime) {
    int time = int.tryParse(setTime) ?? state.timeLimit;
    emit(state.copyWith(timeLimit: time));
  }

  void updateImageUrl(String url) {
    emit(state.copyWith(imageUrl: url));
  }

  void updateQuizTitle(String quizTitle) {
    emit(state.copyWith(quizTitle: quizTitle));
  }

  void updateGameCode(int gameCode) {
    emit(state.copyWith(gameCode: gameCode));
  }

  bool isFormValidQuestion() {
    final answerRegex = RegExp(
      r'^[a-zA-Z0-9\s+\-*/=.,!?()ąćęłńóśźżĄĆĘŁŃÓŚŹŻ]{1,20}$',
    );
    final questionRegex = RegExp(
      r'^[a-zA-Z0-9\s+\-*/=.,!?()ąćęłńóśźżĄĆĘŁŃÓŚŹŻ]{5,80}$',
    );
    final imageUrlRegex = RegExp(
      r"^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\:\d+)?(\/[^\s]*)?\.(jpg|jpeg|png|gif|bmp|webp)$",
    );
    final timeRegex = RegExp(r"^(1[0-9]|[2-9][0-9])$");
    final pointsRegex = RegExp(r"^[1-9]$");

    if (!questionRegex.hasMatch(state.questionText.trim())) {
      return false;
    }

    if (!timeRegex.hasMatch(state.timeLimit.toString())) {
      return false;
    }

    if (!pointsRegex.hasMatch(state.points.toString())) {
      return false;
    }

    for (var answer in state.answerTexts) {
      if (!answerRegex.hasMatch(answer.trim())) {
        return false;
      }
    }

    if (state.correctAnswer.isEmpty) return false;
    if (!imageUrlRegex.hasMatch(state.imageUrl) &&
        state.imageUrl.trim().isNotEmpty) {
      return false;
    }

    return true;
  }

  bool isFormValidQuiz() {
    final qiuzRegex = RegExp(r'^[a-zA-Z0-9\sąćęłńóśźżĄĆĘŁŃÓŚŹŻ]{1,20}$');
    if (state.quizTitle.trim().isEmpty) return false;
    if (!qiuzRegex.hasMatch(state.quizTitle)) return false;
    return true;
  }

  void addQuestion(String userId) {
    final newQuestion = QuestionModel(
      userId: userId,
      question: state.questionText,
      answers: state.answerTexts,
      correctAnswer: state.correctAnswer,
      points: state.points,
      timeLimit: state.timeLimit,
      urlImage: state.imageUrl,
    );

    emit(state.copyWith(
      questions: [...state.questions, newQuestion],
      questionText: '',
      answerTexts: List.generate(state.numberOfAnswers, (index) => ''),
      correctAnswer: '',
      points: 1,
      timeLimit: 30, // domyślny czas
      imageUrl: '',
    ));
  }

  void prepareToEdit(int index, bool isEdit) {
    _indexQuestion = index;
    emit(state.copyWith(
      currentIndex: 1,
      questionText: state.questions[_indexQuestion].question,
      answerTexts: state.questions[_indexQuestion].answers,
      correctAnswer: state.questions[_indexQuestion].correctAnswer,
      timeLimit: state.questions[_indexQuestion].timeLimit,
      numberOfAnswers: state.questions[_indexQuestion].answers.length,
      points: state.questions[_indexQuestion].points,
      imageUrl: state.questions[_indexQuestion].urlImage
    ));
    _editQuestion = true;
  }

  void editQuestion(QuestionModel updatedQuestion) {
    final updatedQuestions = [...state.questions];
    updatedQuestions[_indexQuestion] = updatedQuestion;
    _indexQuestion = -1;
    emit(state.copyWith(
      questions: updatedQuestions,
      questionText: '',
      answerTexts: List.generate(state.numberOfAnswers, (index) => ''),
      correctAnswer: '',
      points: 1,
      timeLimit: 30,
      imageUrl: '',
    ));
    _editQuestion = false;
  }

  void removeQuestion(int index) {
    final updatedQuestions = [...state.questions]..removeAt(index);
    emit(state.copyWith(questions: updatedQuestions));
  }

  void changeNumberOfAnswers(int number) {
     if (number < 0) return;
  
  final List<String> ans = state.answerTexts;

  if (number == ans.length) return;

  emit(state.copyWith(
    numberOfAnswers: number,
    answerTexts: List.generate(
      number, 
      (index) => index < ans.length ? ans[index] : '',
    ),
  ));
  }
}
