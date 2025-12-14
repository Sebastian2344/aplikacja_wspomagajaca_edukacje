import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/game_module/features/commons/main_component/my_platformer_game.dart';
import 'package:quiztale/game_module/features/quiz_menage/cubit/quiz_part_game_cubit.dart';
import 'package:quiztale/game_module/features/quiz_menage/data/model/question_model_game.dart';
import 'package:quiztale/game_module/features/quiz_menage/presentation/overlays/question.dart';

class MockQuizCubit extends Mock implements QuizPartGameCubit {}

class MockGame extends Mock implements PlatformerGame {}

void main() {
  final mockQuestion = QuestionModelGame(
    question: "Jakie jest 2+2?",
    answers: ["1", "4", "3", "5"],
    correctAnswer: '4',
    category: "Matematyka",
  );

  late MockQuizCubit mockCubit;
  late MockGame mockGame;

  setUp(() {
    mockCubit = MockQuizCubit();
    mockGame = MockGame();
    when(() => mockCubit.stream).thenAnswer(
      (_) => Stream<QuizPartGameState>.empty(),
    );
  });

  testWidgets("Pokazuje CircularProgressIndicator dla stanu początkowego",
      (tester) async {
    when(() => mockCubit.state).thenReturn(QuizPartGameInitial());

    await tester.pumpWidget(
      BlocProvider<QuizPartGameCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: Question(game: mockGame),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Wyświetla pytanie i odpowiedzi w AnsweringIsReadyToUse",
      (tester) async {
    when(() => mockCubit.state).thenReturn(AnsweringIsReadyToUse(mockQuestion));

    await tester.pumpWidget(
      BlocProvider<QuizPartGameCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: Question(game: mockGame),
        ),
      ),
    );

    expect(find.text("Jakie jest 2+2?"), findsOneWidget);
    expect(find.text("1"), findsOneWidget);
    expect(find.text("4"), findsOneWidget);
    expect(find.text("3"), findsOneWidget);
    expect(find.text("5"), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(4));
  });

  testWidgets("Wyświetla pytanie i odpowiedzi w CheckedAnswer",
      (tester) async {
     when(() => mockCubit.state).thenReturn(
      CheckedAnswer(
        mockQuestion,
        Colors.green,
        Colors.red,
        Colors.red,
        Colors.red,
      ),
    );

    await tester.pumpWidget(
      BlocProvider<QuizPartGameCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: Question(game: mockGame),
        ),
      ),
    );

    expect(find.text("Jakie jest 2+2?"), findsOneWidget);
    expect(find.text("1"), findsOneWidget);
    expect(find.text("4"), findsOneWidget);
    expect(find.text("3"), findsOneWidget);
    expect(find.text("5"), findsOneWidget);
    expect(find.byType(Container), findsNWidgets(5));
  });

  testWidgets("Tap na odpowiedź wywołuje checkAnswer", (tester) async {
    when(() => mockCubit.state).thenReturn(AnsweringIsReadyToUse(mockQuestion));

    await tester.pumpWidget(
      BlocProvider<QuizPartGameCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: Question(game: mockGame),
        ),
      ),
    );

    await tester.tap(find.text("1"));
    await tester.pump();

    verify(() => mockCubit.chechAnswer("1", 0)).called(1);
  });

  testWidgets("Wyświetla kolorowe odpowiedzi w CheckedAnswer", (tester) async {
    when(() => mockCubit.state).thenReturn(
      CheckedAnswer(
        mockQuestion,
        Colors.green,
        Colors.red,
        Colors.red,
        Colors.red,
      ),
    );

    await tester.pumpWidget(
      BlocProvider<QuizPartGameCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: Question(game: mockGame),
        ),
      ),
    );

    final containers = tester.widgetList<Container>(
    find.byType(Container),
  ).toList();

  // 1 === pytanie, 2–5 === odpowiedzi
  final ans1 = containers[1];
  final ans2 = containers[2];
  final ans3 = containers[3];
  final ans4 = containers[4];

  final deco1 = ans1.decoration as BoxDecoration;
  final deco2 = ans2.decoration as BoxDecoration;
  final deco3 = ans3.decoration as BoxDecoration;
  final deco4 = ans4.decoration as BoxDecoration;

  expect(deco1.color, Colors.green);
  expect(deco2.color, Colors.red);
  expect(deco3.color, Colors.red);
  expect(deco4.color, Colors.red);
  });

  testWidgets(
      "'Zamknij' usuwa overlay, wznawia silnik i wywołuje prepareNextquestion",
      (tester) async {
    when(() => mockCubit.state).thenReturn(
      CheckedAnswer(
        mockQuestion,
        Colors.red,
        Colors.green,
        Colors.red,
        Colors.red,
      ),
    );

    //when(() => mockGame.overlays).thenReturn(
    //  <String>{'quizQuestion'}.toSet(),
    //);

    when(() => mockGame.overlays.remove(any())).thenAnswer((_) {
      return true;
    });
    when(() => mockGame.resumeEngine()).thenAnswer((_) {});
    when(() => mockCubit.prepareNextquestion()).thenAnswer((_) {});

    await tester.pumpWidget(
      BlocProvider<QuizPartGameCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: Question(game: mockGame),
        ),
      ),
    );

    await tester.tap(find.text("Zamknij"));
    await tester.pump();

    verify(() => mockGame.overlays.remove('quizQuestion')).called(1);
    verify(() => mockGame.resumeEngine()).called(1);
    verify(() => mockCubit.prepareNextquestion()).called(1);
  });
}
