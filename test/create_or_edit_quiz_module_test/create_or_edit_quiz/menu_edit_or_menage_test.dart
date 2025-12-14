import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/question_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/quiz_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/cubit/create_or_edit_quiz_cubit.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/presentation/screens/menu_edit_or_menage.dart';

class MockCreateOrEditQuizCubit extends Mock implements CreateOrEditQuizCubit {}

class FakeNavigatorObserver extends Fake implements NavigatorObserver {}

void main() {
  late MockCreateOrEditQuizCubit mockCubit;
  late QuizModel quizModel;
  late List<QuestionModel> questionList;

  setUp(() {
    mockCubit = MockCreateOrEditQuizCubit();

    when(() => mockCubit.state).thenReturn(const CreateQuizInitial());

    quizModel = QuizModel(
      docID: "abc123",
      userId: "user1",
      quizTitle: "Test Quiz",
      gameCode: 111111,
    );

    questionList = [
      QuestionModel(
        userId: "q1",
        question: "Test?",
        answers: ["A", "B", "C"],
        correctAnswer: "A",
        points: 10,
        timeLimit: 30,
        urlImage: ""
      ),
    ];
  });

  testWidgets("MenuEditOrMenage renders all buttons",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockCubit,
          child: MenuEditOrMenage(quizModel: quizModel, list: questionList),
        ),
      ),
    );

    expect(find.text("Wybierz co chczesz zrobić"), findsOneWidget);
    expect(find.text("Edytuj quiz"), findsOneWidget);
    expect(find.text("Zarządzaj quizem"), findsOneWidget);
    expect(find.text("Wyjście"), findsOneWidget);
  });

  testWidgets("Tapping 'Edytuj quiz' pushes EditQuizScreen",
      (WidgetTester tester) async {
    final navigatorObserver = FakeNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [navigatorObserver],
        home: BlocProvider.value(
          value: mockCubit,
          child: MenuEditOrMenage(quizModel: quizModel, list: questionList),
        ),
      ),
    );

    await tester.tap(find.text("Edytuj quiz"));
    await tester.pumpAndSettle();

    verify(() => navigatorObserver.didPush(any(), any())).called(1);
  });

  testWidgets("Tapping 'Zarządzaj quizem' pushes management screen",
      (WidgetTester tester) async {
    final navigatorObserver = FakeNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [navigatorObserver],
        home: BlocProvider.value(
          value: mockCubit,
          child: MenuEditOrMenage(quizModel: quizModel, list: questionList),
        ),
      ),
    );

    await tester.tap(find.text("Zarządzaj quizem"));
    await tester.pumpAndSettle();

    verify(() => navigatorObserver.didPush(any(), any())).called(1);
  });

  testWidgets("Tapping 'Wyjście' calls returnToQuizList() and pops",
      (WidgetTester tester) async {
    final navigatorObserver = FakeNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [navigatorObserver],
        home: BlocProvider.value(
          value: mockCubit,
          child: MenuEditOrMenage(quizModel: quizModel, list: questionList),
        ),
      ),
    );

    await tester.tap(find.text("Wyjście"));
    await tester.pumpAndSettle();

    verify(() => mockCubit.returnToQuizList()).called(1);
    verify(() => navigatorObserver.didPop(any(), any())).called(1);
  });
}
