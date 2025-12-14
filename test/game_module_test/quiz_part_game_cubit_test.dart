import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/game_module/features/quiz_menage/cubit/quiz_part_game_cubit.dart';
import 'package:quiztale/game_module/features/quiz_menage/data/model/question_model_game.dart';
import 'package:quiztale/game_module/features/quiz_menage/data/repository/question_game_repo.dart';

class MockQuestionGameRepo extends Mock implements QuestionGameRepo {}
void main(){
  late final QuizPartGameCubit quizPartGameCubit;
  late final MockQuestionGameRepo mockQuestionGameRepo;

  setUp(() {
    mockQuestionGameRepo = MockQuestionGameRepo();
    quizPartGameCubit = QuizPartGameCubit(mockQuestionGameRepo);
  });

  blocTest<QuizPartGameCubit, QuizPartGameState>(
    'emits [AnsweringIsReadyToUse] when loadQuestions is called',
    build: () {
      when(() => mockQuestionGameRepo.questionsFromJSON(any())).thenAnswer(
        (_) async => [
          QuestionModelGame(
            question: 'Sample Question?',
            answers: ['A', 'B', 'C', 'D'],
            correctAnswer: 'A',
            category: 'Sample Category',
          ),
        ],
      );
      return QuizPartGameCubit(mockQuestionGameRepo);
    },
    act: (cubit) => cubit.loadQuestions('sample_source'),
    expect: () => [
      isA<AnsweringIsReadyToUse>().having(
        (state) => state.questionModelGame.question,'question',contains('Sample Question?')
      ).having(
        (state) => state.questionModelGame.answers,'answers',containsAll(['A','B','C','D'])
      ).having(
        (state) => state.questionModelGame.correctAnswer,'correctAnswer',contains('A')
      ),
    ],
  );

  blocTest('emits [ChechAnswer] when check answer is called',build: () {
     when(() => mockQuestionGameRepo.questionsFromJSON(any())).thenAnswer(
        (_) async => [
          QuestionModelGame(
            question: 'Sample Question?',
            answers: ['A', 'B', 'C', 'D'],
            correctAnswer: 'A',
            category: 'Sample Category',
          ),
        ],
      );
    return quizPartGameCubit;
  },act: (cubit) async{
    await cubit.loadQuestions('sample_source');
    cubit.chechAnswer('A',0);
  },expect: () => [
    isA<AnsweringIsReadyToUse>().having(
      (state) => state.questionModelGame.question,'question',contains('Sample Question?')
    ).having(
      (state) => state.questionModelGame.answers,'answers',containsAll(['A','B','C','D'])
    ).having(
      (state) => state.questionModelGame.correctAnswer,'correctAnswer',contains('A')
    ),
    isA<CheckedAnswer>().having(
      (state) => state.color,'color1',equals(Colors.green)
    ).having(
      (state) => state.color2,'color2',equals(Colors.red)
    ).having(
      (state) => state.color3,'color3',equals(Colors.red)
    ).having(
      (state) => state.color4,'color4',equals(Colors.red)
    ),
  ],);


  blocTest('prepareNextquestion() returns [AnsweringIsReadyToUse]', build: () {
     when(() => mockQuestionGameRepo.questionsFromJSON(any())).thenAnswer(
        (_) async => [
          QuestionModelGame(
            question: 'Sample Question?',
            answers: ['A', 'B', 'C', 'D'],
            correctAnswer: 'A',
            category: 'Sample Category',
          ),
          QuestionModelGame(
            question: 'Sample Question2?',
            answers: ['A', 'B', 'C', 'D'],
            correctAnswer: 'A',
            category: 'Sample Category',
          ),
        ],
      );
    return quizPartGameCubit;
  },act: (cubit) async{
    await cubit.loadQuestions('sample_source');
    cubit.prepareNextquestion();
  },expect: () => [
    isA<AnsweringIsReadyToUse>(),
    isA<AnsweringIsReadyToUse>().having(
      (state) => state.questionModelGame.question,'question',contains('Sample Question2?')
    ).having(
      (state) => state.questionModelGame.answers,'answers',containsAll(['A','B','C','D'])
    ).having(
      (state) => state.questionModelGame.correctAnswer,'correctAnswer',contains('A')
    ),
  ],);

  blocTest('prepareNextquestion() returns nothing', build: () {
     when(() => mockQuestionGameRepo.questionsFromJSON(any())).thenAnswer(
        (_) async => [
          QuestionModelGame(
            question: 'Sample Question?',
            answers: ['A', 'B', 'C', 'D'],
            correctAnswer: 'A',
            category: 'Sample Category',
          ),
        ],
      );
    return quizPartGameCubit;
  },act: (cubit) async{
    await cubit.loadQuestions('sample_source');
    cubit.prepareNextquestion();
  },expect: () => [
    isA<AnsweringIsReadyToUse>(),
  ],);
}