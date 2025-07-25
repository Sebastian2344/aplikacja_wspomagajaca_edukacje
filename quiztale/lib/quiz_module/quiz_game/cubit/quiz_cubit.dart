import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/timer_cubit.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/user_answer_cubit.dart';

import '../../commons/model/question_model.dart';
import '../../commons/model/solved_quiz_model.dart';
import '../data/repository/quiz_repository.dart';
import '../../commons/exceptions/exceptions.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit(this._repository, this._timerCubit, this._userAnswerCubit)
      : super(const QuizInitialState());
  final QuizRepository _repository;
  final TimerCubit _timerCubit;
  final UserAnswerCubit _userAnswerCubit;
  List<QuestionModel> _questionList = [];
  StreamSubscription<TimerState>? _timerSubscription;
  StreamSubscription? _settingsSubscription;
  int _questionIndex = 0;
  int _points = 0;
  String _idPlayer = '';


  Future<void> turnOnTheQuizMechanism(String idQuiz,int gameCode,String userNickname,String quizOwnerId) async {
    
    if(_questionList.isEmpty){
      final questions = await _repository.getQuestions(idQuiz);
      questions.fold((l) => emit(QuizError(l,idQuiz,userNickname,gameCode,quizOwnerId)), (r) => _questionList = r);
      if (state is QuizError) return;
    }

    final settings = await _repository.getSettings(gameCode);

    settings.fold((left) {
      emit(QuizError(left,idQuiz,userNickname,gameCode,quizOwnerId));
    }, (right) {
      _settingsSubscription = right.listen((data) async {
        if (data.start == true && data.nextQuestion == false && data.pause == false && data.end == false) {
          _showQuestion(_questionList, _questionIndex, userNickname,idQuiz,quizOwnerId);
        } else if (data.nextQuestion) {
          _questionIndex++;
        } else if (data.pause && data.nextQuestion == false) {
          _timerCubit.stopTimer();
          emit(const ShowPauseQuiz());
        } else if (data.end && data.pause == false && data.nextQuestion == false) {
          await _finishQuiz(userNickname,idQuiz,quizOwnerId);
        } else {null;}
      },
          onError: (error) => emit(QuizError(
              UnknownException(error: 'Wystąpił błąd: ${error.toString()}'),idQuiz,userNickname,gameCode,quizOwnerId)));
    });
  }

  Future<void> repeatFinishQuiz(String userNickname,String idQuiz,String quizOwnerId) async {
    _settingsSubscription?.cancel();
    await _finishQuiz(userNickname,idQuiz,quizOwnerId);
  }

  void _showQuestion(
      List<QuestionModel> quizList, int index, String userNickname,String idQuiz,String quizOwnerId) {
    QuestionModel question = quizList[index];

    emit(ShowQuestion(question));
    _timerCubit.startTimer(question.timeLimit);
    _timerSubscription?.cancel();

    _timerSubscription = _timerCubit.stream.asBroadcastStream().listen((timerState) async {
      if (timerState is TimerRunning) {
        if (timerState.remainingTime == 0 && _timerCubit.isCheckingAnswer == false) {
          _checkUserAnswer(quizList, index, question);
        }
      } else if (timerState is TimerCompleted && _timerCubit.isCheckingAnswer == true) {
        await _handleNextQuestion(quizList, index, userNickname,idQuiz,quizOwnerId);
      }
    });
  }

  void _checkUserAnswer(
      List<QuestionModel> quizList, int index, QuestionModel question) async {
    String userAnswer = _userAnswerCubit.lastChoice();
    bool isCorrect = userAnswer == question.correctAnswer;

    if (isCorrect) {
      _points += question.points;
    }

    emit(ShowCorrectAnswer(question, isCorrect));
    _userAnswerCubit.initStateUserAnswer();
    _timerCubit.startCheckingAnswerTimer();
  }

  Future<void> _handleNextQuestion(
      List<QuestionModel> quizList, int index, String userNickname,String idQuiz,String quizOwnerId) async {
    if (_questionIndex < quizList.length - 1) {
      _questionIndex++;
      _showQuestion(quizList, _questionIndex, userNickname,idQuiz,quizOwnerId);
    } else {
      await _finishQuiz(userNickname,idQuiz,quizOwnerId);
    }
  }

  Future<void> _finishQuiz(String userNickname,String idQuiz,String quizOwnerId) async {
    if (_idPlayer == '') {
      final e = await _repository.putSolvedQuiz(_points, userNickname, idQuiz, quizOwnerId);
      e.fold((left) {
        emit(QuizFinishError(left,idQuiz,userNickname,quizOwnerId));
      }, (right) {
        _idPlayer = right;
      });
    }
    if (state is! QuizFinishError) {
      Future.delayed(const Duration(seconds: 1));
      final s = await _repository.getSolvedQuizies(idQuiz);
      s.fold((left) {
        emit(QuizFinishError(left,idQuiz,userNickname,quizOwnerId));
      }, (right) {
        emit(ShowEndScreen(right));
      });
    }
  }

  @override
  Future<void> close() async {
    await _settingsSubscription?.cancel();
    await _timerSubscription?.cancel();
    return super.close();
  }
}
