import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/question_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/quiz_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/cubit/create_or_edit_quiz_cubit.dart';
import 'package:quiztale/create_or_edit_quiz_module/create_or_edit_quiz/presentation/widgets/edit.dart';
import 'package:quiztale/create_or_edit_quiz_module/quiz_panel/cubit/quiz_panel_cubit.dart';
import 'package:quiztale/create_or_edit_quiz_module/quiz_panel/presentation/screens/edit_quiz_screen.dart';
import 'package:quiztale/create_or_edit_quiz_module/quiz_panel/presentation/widgets/edit_question_widget.dart';
import 'package:quiztale/create_or_edit_quiz_module/quiz_panel/presentation/widgets/show_panel_questions.dart';

import '../../create_or_edit_quiz/menu_create_or_edit_test.dart';

class MockQuizPanelCubit extends Mock implements QuizPanelCubit {}

void main() {
  late MockQuizPanelCubit mockCubit;
  late MockCreateOrEditQuizCubit mockCreateOrEditQuizCubit;

  setUp(() {
    mockCubit = MockQuizPanelCubit();
    mockCreateOrEditQuizCubit = MockCreateOrEditQuizCubit();
    when(() => mockCreateOrEditQuizCubit.state)
        .thenReturn(DownloadedSelectedQuiz([
      QuestionModel(
          userId: 'userId',
          question: 'question',
          answers: ['heh'],
          correctAnswer: 'correctAnswer',
          points: 1,
          timeLimit: 30,
          urlImage: 'urlImage')
    ], QuizModel(docID: '', userId: '', gameCode: 123456, quizTitle: '')));
    when(() => mockCreateOrEditQuizCubit.stream)
        .thenAnswer((_) => Stream.empty());
    when(() => mockCubit.state).thenReturn(QuizPanelState());
    when(() => mockCubit.stream)
        .thenAnswer((_) => Stream<QuizPanelState>.empty());
    when(() => mockCubit.isEdit()).thenReturn(false);
    when(() => mockCubit.isFormValidQuiz()).thenReturn(true);
    when(() => mockCubit.close()).thenAnswer((_) => Future.value());
    when(() => mockCreateOrEditQuizCubit.close())
        .thenAnswer((_) => Future.value());
  });

  Widget makeTestableWidget({required int currentIndex}) {
    final quizModel = QuizModel(
      docID: "doc123",
      userId: "user123",
      quizTitle: "Test Quiz",
      gameCode: 1111,
    );

    final questions = [
      QuestionModel(
        userId: "user123",
        question: "Q1",
        answers: ["A", "B", "C"],
        correctAnswer: "A",
        points: 1,
        timeLimit: 30,
        urlImage: "",
      ),
    ];

    when(() => mockCubit.state).thenReturn(
      QuizPanelState(currentIndex: currentIndex),
    );

    return MaterialApp(
      home: BlocProvider<CreateOrEditQuizCubit>.value(
        value: mockCreateOrEditQuizCubit,
        child: BlocProvider<QuizPanelCubit>.value(
          value: mockCubit,
          child: EditQuizScreen(
            downloadedQuizModel: quizModel,
            downloadedListQuestionModel: questions,
            quizPanelCubit: mockCubit,
          ),
        ),
      ),
    );
  }

  group('description', () {
    testWidgets('renders Edit widget when currentIndex is 0', (tester) async {
      await tester.pumpWidget(makeTestableWidget(currentIndex: 0));
      expect(find.byType(Edit), findsOneWidget);
    });

    testWidgets('renders EditQuestionWidget when currentIndex is 1',
        (tester) async {
      await tester.pumpWidget(makeTestableWidget(currentIndex: 1));
      expect(find.byType(EditQuestionWidget), findsOneWidget);
    });

    testWidgets('renders ShowPanelQuestions when currentIndex is other',
        (tester) async {
      await tester.pumpWidget(makeTestableWidget(currentIndex: 2));
      expect(find.byType(ShowPanelQuestions), findsOneWidget);
    });

    testWidgets('BottomNavigationBar taps call updateIndex on cubit',
        (tester) async {
      when(() => mockCubit.updateIndex(any())).thenReturn(null);

      await tester.pumpWidget(makeTestableWidget(currentIndex: 0));

      await tester.tap(find.text('Edytuj pytania'));
      await tester.pumpAndSettle();
      verify(() => mockCubit.updateIndex(1)).called(1);

      await tester.tap(find.text('Lista pytań'));
      await tester.pumpAndSettle();
      verify(() => mockCubit.updateIndex(2)).called(1);
    });

    testWidgets('AppBar displays correct title', (tester) async {
      await tester.pumpWidget(makeTestableWidget(currentIndex: 0));
      expect(find.text('Edycja quizu'), findsOneWidget);
    });

    testWidgets('BottomNavigationBar shows correct currentIndex',
        (tester) async {
      await tester.pumpWidget(makeTestableWidget(currentIndex: 1));
      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 1);
    });
  });
}
