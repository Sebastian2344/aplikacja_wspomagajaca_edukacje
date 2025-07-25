import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'level_state.dart';

class LevelsMenagmentCubit extends Cubit<LevelsMenagmentState> {
  LevelsMenagmentCubit() : super(const LevelsMenagmentState(currentLevel: 1,collectedBox: 0,howMuchQuestionsBoxLeft: 5));

  void nextLevel() {
    emit(state.copyWith(currentLevel: state.currentLevel + 1,collectedBox: 0,howMuchQuestionsBoxLeft: 5,isLevelCompleted: false,isPreparedLevel: false));
  }

  void isCompleteLevel() {
    if(state.collectedBox == 5 && state.howMuchQuestionsBoxLeft == 0){
      emit(state.copyWith(isLevelCompleted: true)); 
    }else{
      emit(state.copyWith(isLevelCompleted: false)); 
    }
    if(state.currentLevel == state.finalLevel && state.isLevelCompleted){
      emit(state.copyWith(isEndGame: true));
    }  
  } 

  void collectQuestionBox(){
    emit(state.copyWith(howMuchQuestionsBoxLeft: state.howMuchQuestionsBoxLeft - 1,collectedBox: state.collectedBox + 1));
  }
  
  void preparedLevel(){
    emit(state.copyWith(isPreparedLevel: true));
  }

  void pauseOn(){
    emit(state.copyWith(isPausedGame: true));
  }

  void pauseOff(){
    emit(state.copyWith(isPausedGame: false));
  }
}