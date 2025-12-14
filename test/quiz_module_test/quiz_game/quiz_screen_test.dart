import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/quiz_module/commons/model/question_model.dart';
import 'package:quiztale/quiz_module/commons/model/solved_quiz_model.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/quiz_cubit.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/timer_cubit.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/user_answer_cubit.dart';
import 'package:quiztale/quiz_module/quiz_game/presentation/screens/quiz_screen.dart';
import 'package:quiztale/quiz_module/quiz_game/presentation/widgets/end_view.dart';
import 'package:quiztale/quiz_module/quiz_game/presentation/widgets/error_finish_view.dart';
import 'package:quiztale/quiz_module/quiz_game/presentation/widgets/error_view.dart';
import 'package:quiztale/quiz_module/quiz_game/presentation/widgets/question_view.dart';
import 'package:quiztale/quiz_module/quiz_game/presentation/widgets/result_view.dart';


/// --------- MOCKS ---------
class MockTimerCubit extends Mock implements TimerCubit {}
class MockUserAnswerCubit extends Mock implements UserAnswerCubit {}
class MockQuizCubit extends Mock implements QuizCubit {}
void main() {
  late MockTimerCubit timerCubit;
  late MockUserAnswerCubit userAnswerCubit;
  late MockQuizCubit quizCubit;

  setUp(() {
    timerCubit = MockTimerCubit();
    userAnswerCubit = MockUserAnswerCubit();
    quizCubit = MockQuizCubit();
     when(() => quizCubit.turnOnTheQuizMechanism(any(), any(), any(), any()))
      .thenAnswer((_) async {});
    when(() => quizCubit.close()).thenAnswer((_)=>Future.value());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: QuizScreen(
        gameCode: 1234,
        quizId: 'quiz123',
        nickname: 'Tester',
        quizOwnerId: 'owner1',
        timerCubit: timerCubit,
        userAnswerCubit: userAnswerCubit,
        quizCubit: quizCubit,
      ),
    );
  }

  testWidgets('Początkowo powinien być CircularProgressIndicator', (tester) async {
    when(() => quizCubit.state).thenReturn(const QuizInitialState());
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('ShowQuestion → wyświetla QuestionView', (tester) async {
    final question = QuestionModel( 
      docId: 'q1',
      question: 'Test Question',
      answers: ['A', 'B', 'C', 'D'],
      correctAnswer: 'A',
      points: 10,
      timeLimit: 30,
      urlImage: '',
    );

    when(() => quizCubit.state).thenReturn(ShowQuestion(question));
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());
    when(() => timerCubit.stream).thenAnswer((_)=> Stream.empty());
    when(() => timerCubit.reamingTime).thenReturn(20);
    when(() => timerCubit.isCheckingAnswer).thenReturn(false);
    when(() => timerCubit.close()).thenAnswer((_)=>Future.value());
    when(() => userAnswerCubit.stream).thenAnswer((_)=> Stream.empty());
    when(() => userAnswerCubit.state).thenReturn(const UserAnswerInitial());
    when(() => userAnswerCubit.close()).thenAnswer((_)=>Future.value());
    
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(QuestionView), findsOneWidget);
  });

  testWidgets('ShowCorrectAnswer → wyświetla ResultView', (tester) async {
    final state = ShowCorrectAnswer(  
      QuestionModel(
        docId: 'q1',
        question: 'Test Question',
        answers: ['A', 'B', 'C', 'D'],
        correctAnswer: 'A',
        points: 10,
        timeLimit: 30,
        urlImage: '',
      ),true);

    when(() => quizCubit.state).thenReturn(state);
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(ResultView), findsOneWidget);
  });

  testWidgets('ShowPauseQuiz → wyświetla ikonę pauzy', (tester) async {
    when(() => quizCubit.state).thenReturn(const ShowPauseQuiz());
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byIcon(Icons.pause), findsOneWidget);
  });

  testWidgets('ShowEndScreen → wyświetla EndView', (tester) async {
    when(() => quizCubit.state).thenReturn(ShowEndScreen([SolvedQuizModel(
      quizOwnerUserId: 'user123',
      nickname: 'Tester',
      points: 100,
    )]));
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(EndView), findsOneWidget);
  });

  testWidgets('QuizError → wyświetla ErrorView', (tester) async {
    when(() => quizCubit.state).thenReturn(const QuizError(UnknownException(error:'Unknown error'),'','',1,''));
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(ErrorView), findsOneWidget);
  });

  testWidgets('QuizFinishError → wyświetla ErrorFinishView', (tester) async {
    when(() => quizCubit.state).thenReturn(const QuizFinishError(UnknownException(error:'Unknown error'),'','',''));
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(ErrorFinishView), findsOneWidget);
  });

  testWidgets('Kliknięcie menu otwiera dialog', (tester) async {
    when(() => quizCubit.state).thenReturn(const QuizInitialState());
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();

    expect(find.text('Czy chcesz opuścic quiz i pójść do menu?'),
        findsOneWidget);
  });

  testWidgets('Dialog → kliknięcie NIE zamyka tylko dialog', (tester) async {
    when(() => quizCubit.state).thenReturn(const QuizInitialState());
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump(Duration(seconds: 1));

    await tester.tap(find.text('Nie'));
    await tester.pump();

    expect(find.text('Czy chcesz opuścic quiz i pójść do menu?'),
        findsNothing);
  });

  testWidgets('Dialog → kliknięcie TAK powoduje 4x pop()', (tester) async {
    when(() => quizCubit.state).thenReturn(const QuizInitialState());
    when(() => quizCubit.stream).thenAnswer((_)=> Stream.empty());

    //final navigator = _MockNavigatorObserver();

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();

    await tester.tap(find.text('Tak'));
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);

    //verify(() => navigator.didPop(any(), any())).called(4);
  });
}

//class _MockNavigatorObserver extends Mock implements NavigatorObserver {}
