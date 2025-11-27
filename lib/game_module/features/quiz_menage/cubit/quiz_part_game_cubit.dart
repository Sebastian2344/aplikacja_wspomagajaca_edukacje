import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/model/question_model_game.dart';
import '../data/repository/question_game_repo.dart';

part 'quiz_part_game_state.dart';

class QuizPartGameCubit extends Cubit<QuizPartGameState> {
  QuizPartGameCubit(this._questionGameRepo) : super(QuizPartGameInitial());
  final QuestionGameRepo _questionGameRepo;
  List<QuestionModelGame> _questions = [];
  int _points = 0;
  int _questionIndex = 0;
  int get points => _points;
  int get questionIndex => _questionIndex;
  
  Future<void> loadQuestions(String source) async {
     _questions = await _questionGameRepo.questionsFromJSON(source);
      emit((AnsweringIsReadyToUse(_questions[0])));
  }

  void chechAnswer(String option,int optionIndex) {
    Color color1 = Colors.red;
    Color color2 = Colors.red;
    Color color3 = Colors.red;
    Color color4 = Colors.red;

    if(_questions[_questionIndex].answers[0] == _questions[_questionIndex].correctAnswer){
      color1 = Colors.green;
    }
    if(_questions[_questionIndex].answers[1] == _questions[_questionIndex].correctAnswer){
      color2 = Colors.green;
    }
    if(_questions[_questionIndex].answers[2] == _questions[_questionIndex].correctAnswer){
      color3 = Colors.green;
    }
    if(_questions[_questionIndex].answers[3] == _questions[_questionIndex].correctAnswer){
      color4 = Colors.green;
    }

    if(option == _questions[_questionIndex].correctAnswer){
      _points++;
    }
    emit(CheckedAnswer(_questions[_questionIndex],color1,color2,color3,color4));
  }

  void prepareNextquestion(){
    if(_questionIndex < _questions.length - 1){
      _questionIndex = _questionIndex + 1;
      emit(AnsweringIsReadyToUse(_questions[_questionIndex]));
    }
  }
}
