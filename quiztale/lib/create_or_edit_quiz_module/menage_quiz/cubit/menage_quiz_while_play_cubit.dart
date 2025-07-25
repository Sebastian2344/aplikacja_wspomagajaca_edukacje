import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../commons/models/quiz_config_model.dart';
import '../data/repository/menage_quiz_while_play_repo.dart';
import '../../commons/exceptions/exceptions.dart';

part 'menage_quiz_while_play_state.dart';

class MenageQuizWhilePlayCubit extends Cubit<MenageQuizState> {
  MenageQuizWhilePlayCubit(this._menageQuizRepo) : super(const MenageQuizInitial());
  final MenageQuizWhilePlayRepo _menageQuizRepo;
  MaterialColor _setStart = Colors.red;
  MaterialColor _setPause = Colors.red;
  MaterialColor _setEnd = Colors.red;
  MaterialColor _setNextQuestion = Colors.red;

  Future<void> setInitialColors(int gameCode) async {
    emit(MenageQuizLoading());
    late QuizConfigModel quizConfigModel;
    final quizConfig = await _menageQuizRepo.downloadQuizConfig(gameCode);
    quizConfig.fold((left) => emit(MenageQuizError(left)), (right) => quizConfigModel = right);

    quizConfigModel.start == false
        ?  _setStart = Colors.red
        :  _setStart = Colors.green;

    quizConfigModel.pause == false
        ? _setPause = Colors.red
        : _setPause = Colors.green;

    quizConfigModel.end == false
        ? _setEnd = Colors.red
        : _setEnd = Colors.green;

    quizConfigModel.nextQuestion == false
        ? _setNextQuestion = Colors.red
        : _setNextQuestion = Colors.green;

    emit(MenageQuizButtonsColors(_setStart, _setNextQuestion, _setPause, _setEnd));
  }

  Future<void> setStart(int gameCode,String quizId) async {
    late QuizConfigModel quizConfigModel;
    emit(MenageQuizButtonsColors(Colors.orange, _setNextQuestion, _setPause, _setEnd));
    final deletedQuiz = await _menageQuizRepo.deleteStats(quizId);
    deletedQuiz.fold((left) => emit(MenageQuizError(left)), (_) {});
    final quizConfig = await _menageQuizRepo.downloadQuizConfig(gameCode);
    quizConfig.fold((left) => emit(MenageQuizError(left)), (right) => quizConfigModel = right);

    quizConfigModel.start
        ? {quizConfigModel.start = false, _setStart = Colors.red}
        : {quizConfigModel.start = true, _setStart = Colors.green};
    
    final setQuizConfigResult = await _menageQuizRepo.setSettings(
        quizConfigModel.docId, quizConfigModel);
    setQuizConfigResult.fold((left) => emit(MenageQuizError(left)), (_) => emit(MenageQuizButtonsColors(_setStart, _setNextQuestion, _setPause, _setEnd)));
  }

  Future<void> setNextQuestion(int gameCode) async {
    late QuizConfigModel quizConfigModel;
    emit(MenageQuizButtonsColors(_setStart, Colors.orange, _setPause, _setEnd));
    
    final quizConfig = await _menageQuizRepo.downloadQuizConfig(gameCode);
    quizConfig.fold((left) => emit(MenageQuizError(left)), (right) => quizConfigModel = right);

    quizConfigModel.nextQuestion = true;
    _setNextQuestion = Colors.green;

    final setQuizConfigResult = await _menageQuizRepo.setSettings(
        quizConfigModel.docId, quizConfigModel);
    setQuizConfigResult.fold((left) => emit(MenageQuizError(left)), (_) => emit(MenageQuizButtonsColors(_setStart, _setNextQuestion, _setPause, _setEnd)));

    quizConfigModel.nextQuestion = false;
    _setNextQuestion = Colors.red;

    final setQuizConfigResult2 = await _menageQuizRepo.setSettings(
        quizConfigModel.docId, quizConfigModel);
    setQuizConfigResult2.fold((left) => emit(MenageQuizError(left)), (_) => emit(MenageQuizButtonsColors(_setStart, _setNextQuestion, _setPause, _setEnd)));
  }

  Future<void> setPause(int gameCode) async {
    late QuizConfigModel quizConfigModel;
    emit(MenageQuizButtonsColors(_setStart, _setNextQuestion, Colors.orange
    , _setEnd));
    final quizConfig = await _menageQuizRepo.downloadQuizConfig(gameCode);
    quizConfig.fold((left) => emit(MenageQuizError(left)), (right) => quizConfigModel = right);

    quizConfigModel.pause
        ? {quizConfigModel.pause = false, _setPause = Colors.red}
        : {quizConfigModel.pause = true, _setPause = Colors.green};

    final setQuizConfigResult = await _menageQuizRepo.setSettings(
        quizConfigModel.docId, quizConfigModel);
    setQuizConfigResult.fold((left) => emit(MenageQuizError(left)), (_) => emit(MenageQuizButtonsColors(_setStart, _setNextQuestion, _setPause, _setEnd)));
  }

  Future<void> setEnd(int gameCode) async {
    late QuizConfigModel quizConfigModel;
    emit(MenageQuizButtonsColors(_setStart, _setNextQuestion, _setPause,Colors.orange));
    final quizConfig = await _menageQuizRepo.downloadQuizConfig(gameCode);
    quizConfig.fold((left) => emit(MenageQuizError(left)), (right) => quizConfigModel = right);

    quizConfigModel.end
        ? {quizConfigModel.end = false, _setEnd = Colors.red}
        : {quizConfigModel.end = true, _setEnd = Colors.green};

    final setQuizConfigResult = await _menageQuizRepo.setSettings(
        quizConfigModel.docId, quizConfigModel);
    setQuizConfigResult.fold((left) {
      
      emit(MenageQuizError(left));} , (_) => emit(MenageQuizButtonsColors(_setStart, _setNextQuestion, _setPause, _setEnd)));
  }
}
