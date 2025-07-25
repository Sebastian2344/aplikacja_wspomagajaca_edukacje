import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'user_answer_state.dart';

class UserAnswerCubit extends Cubit<UserAnswerState> {
  UserAnswerCubit() : super(const UserAnswerInitial());
  List<Icon?> _icons = [Icon(Icons.circle_outlined),Icon(Icons.circle_outlined),Icon(Icons.circle_outlined),Icon(Icons.circle_outlined)];
  String _answer = '';

  void initStateUserAnswer(){
    _icons = [Icon(Icons.circle_outlined),Icon(Icons.circle_outlined),Icon(Icons.circle_outlined),Icon(Icons.circle_outlined)];
    _answer = '';
    emit(const UserAnswerInitial());
  }

  void setCheckIconAnswer(String checkedAns,List<String> answers){
    _answer = checkedAns;
    for(int i = 0; i < answers.length; i++){
      if(checkedAns == answers[i]){
        _icons[i] = const Icon(Icons.check_circle_outline);
      }
    }
    
    emit(UserAnswerIcon(_icons));
  }

  String lastChoice(){
    return _answer;
  }
}
