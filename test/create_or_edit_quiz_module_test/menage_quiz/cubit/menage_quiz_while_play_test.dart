import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/quiz_config_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/menage_quiz/cubit/menage_quiz_while_play_cubit.dart';
import 'package:quiztale/create_or_edit_quiz_module/menage_quiz/data/repository/menage_quiz_while_play_repo.dart';

class MockMenageQuizRepo extends Mock implements MenageQuizWhilePlayRepo {}

void main() {
  late MockMenageQuizRepo repo;
  late MenageQuizWhilePlayCubit cubit;

  final quizConfig = QuizConfigModel(
    docId: "test123",
    start: false,
    pause: false,
    end: false,
    nextQuestion: false,
    gameCode: 111,
    userId: "userid123",
  );

  setUp(() {
    repo = MockMenageQuizRepo();
    cubit = MenageQuizWhilePlayCubit(repo);
  });

  group("MenageQuizWhilePlayCubit Tests", () {

    // --------------------------------------------------------------------------
    // TEST: setInitialColors
    // --------------------------------------------------------------------------
    blocTest<MenageQuizWhilePlayCubit, MenageQuizState>(
      "setInitialColors() -> emits loading + final button colors",
      build: () {
        when(() => repo.downloadQuizConfig(111))
            .thenAnswer((_) async => Right(quizConfig));
        return cubit;
      },
      act: (c) => c.setInitialColors(111),
      expect: () => [
        isA<MenageQuizLoading>(),
        MenageQuizButtonsColors(
          Colors.red,
          Colors.red,
          Colors.red,
          Colors.red,
        ),
      ],
    );

    // --------------------------------------------------------------------------
    // TEST: setStart
    // --------------------------------------------------------------------------
    blocTest<MenageQuizWhilePlayCubit, MenageQuizState>(
      "setStart() -> toggles start and emits new colors",
      build: () {
        when(() => repo.deleteStats("quiz1"))
            .thenAnswer((_) async => const Right(null));

        when(() => repo.downloadQuizConfig(111))
            .thenAnswer((_) async => Right(quizConfig));

        when(() => repo.setSettings(any(), any()))
            .thenAnswer((_) async => const Right(null));

        return cubit;
      },
      act: (c) => c.setStart(111, "quiz1"),
      expect: () => [
        // pressed -> button temporary orange
        MenageQuizButtonsColors(
          Colors.orange,
          Colors.red,
          Colors.red,
          Colors.red,
        ),
        // saved -> green
        MenageQuizButtonsColors(
          Colors.green,
          Colors.red,
          Colors.red,
          Colors.red,
        ),
      ],
    );

    // --------------------------------------------------------------------------
    // TEST: setPause
    // --------------------------------------------------------------------------
    blocTest<MenageQuizWhilePlayCubit, MenageQuizState>(
      "setPause() -> toggles pause color",
      build: () {
        when(() => repo.downloadQuizConfig(111))
            .thenAnswer((_) async => Right(quizConfig));

        when(() => repo.setSettings(any(), any()))
            .thenAnswer((_) async => const Right(null));

        return cubit;
      },
      act: (c) => c.setPause(111),
      expect: () => [
        MenageQuizButtonsColors(
          Colors.red,
          Colors.red,
          Colors.orange,
          Colors.red,
        ),
        MenageQuizButtonsColors(
          Colors.red,
          Colors.red,
          Colors.green,
          Colors.red,
        ),
      ],
    );

    // --------------------------------------------------------------------------
    // TEST: setNextQuestion
    // --------------------------------------------------------------------------
    blocTest<MenageQuizWhilePlayCubit, MenageQuizState>(
      "setNextQuestion() -> true then false",
      build: () {
        when(() => repo.downloadQuizConfig(111))
            .thenAnswer((_) async => Right(quizConfig));

        when(() => repo.setSettings(any(), any()))
            .thenAnswer((_) async => const Right(null));

        return cubit;
      },
      act: (c) => c.setNextQuestion(111),
      expect: () => [
        // Initial orange
        MenageQuizButtonsColors(
          Colors.red,
          Colors.orange,
          Colors.red,
          Colors.red,
        ),
        // NextQuestion true -> green
        MenageQuizButtonsColors(
          Colors.red,
          Colors.green,
          Colors.red,
          Colors.red,
        ),
        // NextQuestion false -> red
        MenageQuizButtonsColors(
          Colors.red,
          Colors.red,
          Colors.red,
          Colors.red,
        ),
      ],
    );

    // --------------------------------------------------------------------------
    // TEST: setEnd
    // --------------------------------------------------------------------------
    blocTest<MenageQuizWhilePlayCubit, MenageQuizState>(
      "setEnd() -> toggles end button",
      build: () {
        when(() => repo.downloadQuizConfig(111))
            .thenAnswer((_) async => Right(quizConfig));

        when(() => repo.setSettings(any(), any()))
            .thenAnswer((_) async => const Right(null));

        return cubit;
      },
      act: (c) => c.setEnd(111),
      expect: () => [
        MenageQuizButtonsColors(
          Colors.red,
          Colors.red,
          Colors.red,
          Colors.orange,
        ),
        MenageQuizButtonsColors(
          Colors.red,
          Colors.red,
          Colors.red,
          Colors.green,
        ),
      ],
    );
  });
}