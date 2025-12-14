import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/quiz_module/commons/model/question_model.dart';
import 'package:quiztale/quiz_module/commons/model/settings_model.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/quiz_cubit.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/timer_cubit.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/user_answer_cubit.dart';
import 'package:quiztale/quiz_module/quiz_game/data/repository/quiz_repository.dart';

class MockQuizRepository extends Mock implements QuizRepository {}

class MockTimerCubit extends Mock implements TimerCubit {}

class MockUserAnswerCubit extends Mock implements UserAnswerCubit {}


void main() {

  late MockQuizRepository repo;
  late MockTimerCubit timerCubit;
  late MockUserAnswerCubit userAnswerCubit;
  late StreamController<SettingsModel> settingsController;
  late StreamController<TimerState> timerController;

  setUp(() {
    repo = MockQuizRepository();
    timerCubit = MockTimerCubit();
    userAnswerCubit = MockUserAnswerCubit();
    settingsController = StreamController<SettingsModel>();
    timerController = StreamController<TimerState>();
    when(() => timerCubit.isCheckingAnswer).thenAnswer((_) => false);
  });

  tearDown(() {
    settingsController.close();
    timerController.close();
  });

  final question = QuestionModel(
    docId: 'Q1',
    question: '2+2?',
    answers: ['1', '2', '4'],
    correctAnswer: '4',
    points: 10,
    timeLimit: 10,
    urlImage: ''
  );

  final settingsStart = SettingsModel(
    userId: 'owner',
    start: true,
    nextQuestion: false,
    pause: false,
    end: false,
    gameCode: 123,
  );

  final settingsEnd = SettingsModel(
    userId: 'owner',
    start: false,
    nextQuestion: false,
    pause: false,
    end: true,
    gameCode: 123,
  );

  blocTest<QuizCubit, QuizState>(
    'turnOnTheQuizMechanism → emits ShowQuestion when settings.start == true',
    setUp: () {
      when(() => repo.getQuestions("quiz1"))
          .thenAnswer((_) async => Right([question]));

      settingsController = StreamController<SettingsModel>();

      when(() => repo.getSettings(123))
          .thenAnswer((_) async => Right(settingsController.stream));

      when(() => timerCubit.stream).thenAnswer((_) => const Stream.empty());
    },
    build: () => QuizCubit(repo, timerCubit, userAnswerCubit),
    act: (cubit) async {
      cubit.turnOnTheQuizMechanism("quiz1", 123, "Nick", "owner");

      await Future.delayed(Duration.zero);

      settingsController.add(settingsStart);
    },
    expect: () => [
      ShowQuestion(question),
    ],
    verify: (_) {
      verify(() => timerCubit.startTimer(question.timeLimit)).called(1);
    },
  );

  blocTest<QuizCubit, QuizState>(
    'Timer hits 0 → checking answer → ShowCorrectAnswer + startCheckingAnswerTimer',
    setUp: () {
      when(() => repo.getQuestions(any()))
          .thenAnswer((_) async => Right([question]));

      settingsController = StreamController<SettingsModel>();
      when(() => repo.getSettings(any()))
          .thenAnswer((_) async => Right(settingsController.stream));

      when(() => userAnswerCubit.lastChoice())
          .thenReturn(question.correctAnswer);

      when(() => userAnswerCubit.initStateUserAnswer()).thenReturn(null);

      timerController = StreamController<TimerState>();
      when(() => timerCubit.stream).thenAnswer((_) => timerController.stream);
    },
    build: () => QuizCubit(repo, timerCubit, userAnswerCubit),
    act: (cubit) async {
      cubit.turnOnTheQuizMechanism("quiz1", 555, "Nick", "owner");

      await Future.delayed(Duration.zero);

      // Start questions
      settingsController.add(settingsStart);

      await Future.delayed(Duration.zero);

      // Timer reaches 0
      timerController.add(TimerRunning(0));
    },
    expect: () => [
      ShowQuestion(question),
      ShowCorrectAnswer(question, true),
    ],
    verify: (_) {
      verify(() => timerCubit.startCheckingAnswerTimer()).called(1);
    },
  );

  blocTest<QuizCubit, QuizState>(
    'End quiz → emits ShowEndScreen',
    setUp: () {
      when(() => repo.getQuestions(any()))
          .thenAnswer((_) async => Right([question]));

      when(() => repo.putSolvedQuiz(any(), any(), any(), any()))
          .thenAnswer((_) async => Right("playerId"));

      when(() => repo.getSolvedQuizies(any()))
          .thenAnswer((_) async => Right([]));

      settingsController = StreamController<SettingsModel>();
      when(() => repo.getSettings(any()))
          .thenAnswer((_) async => Right(settingsController.stream));
    },
    build: () => QuizCubit(repo, timerCubit, userAnswerCubit),
    act: (cubit) async {
      cubit.turnOnTheQuizMechanism("quizX", 123, "Nick", "owner");
      await Future.delayed(Duration.zero);

      settingsController.add(settingsEnd);
    },
    expect: () => [
      isA<ShowEndScreen>(),
    ],
  );
}
