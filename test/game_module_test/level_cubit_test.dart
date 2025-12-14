import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiztale/game_module/features/level_menage/cubit/level_cubit.dart';

void main() {
  group('description', () {
    blocTest(
      'emits [LevelsMenagmentState] with incremented level when nextLevel is called',
      build: () => LevelsMenagmentCubit(),
      act: (bloc) => bloc.nextLevel(),
      expect: () => [
        LevelsMenagmentState(
            currentLevel: 2,
            collectedBox: 0,
            howMuchQuestionsBoxLeft: 5,
            isLevelCompleted: false,
            isPreparedLevel: false)
      ],
    );

    blocTest(
      'emits [LevelsMenagmentState] with isLevelCompleted true when isCompleteLevel is called and conditions met',
      build: () => LevelsMenagmentCubit()
        ..emit(LevelsMenagmentState(
            currentLevel: 1, collectedBox: 5, howMuchQuestionsBoxLeft: 0)),
      act: (bloc) => bloc.isCompleteLevel(),
      expect: () => [
        LevelsMenagmentState(
            currentLevel: 1,
            collectedBox: 5,
            howMuchQuestionsBoxLeft: 0,
            isLevelCompleted: true)
      ],
    );

    blocTest(
      'emits [LevelsMenagmentState] with updated collectedBox and howMuchQuestionsBoxLeft when collectQuestionBox is called',
      build: () => LevelsMenagmentCubit()
        ..emit(LevelsMenagmentState(
            currentLevel: 1, collectedBox: 2, howMuchQuestionsBoxLeft: 3)),
      act: (bloc) => bloc.collectQuestionBox(),
      expect: () => [
        LevelsMenagmentState(
            currentLevel: 1, collectedBox: 3, howMuchQuestionsBoxLeft: 2)
      ],
    );

    blocTest(
      'emits [LevelsMenagmentState] with isPreparedLevel true when preparedLevel is called',
      build: () => LevelsMenagmentCubit(),
      act: (bloc) => bloc.preparedLevel(),
      expect: () => [
        LevelsMenagmentState(
            currentLevel: 1,
            collectedBox: 0,
            howMuchQuestionsBoxLeft: 5,
            isPreparedLevel: true)
      ],
    );

    blocTest(
      'emits [LevelsMenagmentState] with isPausedGame true when pauseOn is called',
      build: () => LevelsMenagmentCubit(),
      act: (bloc) => bloc.pauseOn(),
      expect: () => [
        LevelsMenagmentState(
            currentLevel: 1,
            collectedBox: 0,
            howMuchQuestionsBoxLeft: 5,
            isPausedGame: true)
      ],
    );

    blocTest(
      'emits [LevelsMenagmentState] with isPausedGame false when pauseOff is called',
      build: () => LevelsMenagmentCubit()
        ..emit(LevelsMenagmentState(
            currentLevel: 1,
            collectedBox: 0,
            howMuchQuestionsBoxLeft: 5,
            isPausedGame: true)),
      act: (bloc) => bloc.pauseOff(),
      expect: () => [
        LevelsMenagmentState(
            currentLevel: 1,
            collectedBox: 0,
            howMuchQuestionsBoxLeft: 5,
            isPausedGame: false)
      ],
    );
  });
}
