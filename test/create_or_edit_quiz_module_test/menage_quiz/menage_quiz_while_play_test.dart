import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/create_or_edit_quiz_module/commons/models/quiz_model.dart';
import 'package:quiztale/create_or_edit_quiz_module/menage_quiz/cubit/menage_quiz_while_play_cubit.dart';
import 'package:quiztale/create_or_edit_quiz_module/menage_quiz/presentation/menage_quiz_while_play_widget.dart';

class MockMenageQuizWhilePlayCubit extends Mock
    implements MenageQuizWhilePlayCubit {}


void main() {
  late MockMenageQuizWhilePlayCubit mockCubit;

  setUp(() {
    mockCubit = MockMenageQuizWhilePlayCubit();
  });

  group("MenageQuizWhilePlayWidget tests", () {
    final model = QuizModel(userId: '',quizTitle: '',gameCode: 111, docID: "DOC1");

    testWidgets("Wyświetla przyciski z poprawnymi kolorami", (tester) async {

      when(() => mockCubit.setInitialColors(any()))
          .thenAnswer((_) async => Future.value());

      whenListen(
        mockCubit,
        Stream.fromIterable([
          MenageQuizButtonsColors(
            Colors.green,
            Colors.red,
            Colors.red,
            Colors.red,
          )
        ]),
        initialState: MenageQuizButtonsColors(
          Colors.green,
          Colors.red,
          Colors.red,
          Colors.red,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MenageQuizWhilePlayWidget(
            downloadedQuizModel: model,
            menageQuiz: mockCubit,
          ),
        ),
      );

      await tester.pump(); // FutureBuilder first frame
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.text("Rozpocznij quiz"), findsOneWidget);

      expect(find.byIcon(Icons.pause), findsOneWidget);
      expect(find.text("Zapauzuj quiz"), findsOneWidget);

      expect(find.byIcon(Icons.arrow_circle_right), findsOneWidget);
      expect(find.text("Następne pytanie"), findsOneWidget);

      expect(find.byIcon(Icons.stop), findsOneWidget);
      expect(find.text("Zakończ quiz"), findsOneWidget);
    });

    testWidgets("Kliknięcie przycisków wywołuje odpowiednie metody Cubita",
        (tester) async {

      when(() => mockCubit.setInitialColors(any()))
          .thenAnswer((_) async => Future.value());

      when(() => mockCubit.setStart(any(), any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockCubit.setPause(any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockCubit.setNextQuestion(any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockCubit.setEnd(any()))
          .thenAnswer((_) async => Future.value());

      whenListen(
        mockCubit,
        Stream.fromIterable([
          MenageQuizButtonsColors(
            Colors.green,
            Colors.red,
            Colors.red,
            Colors.red,
          )
        ]),
        initialState: MenageQuizButtonsColors(
          Colors.green,
          Colors.red,
          Colors.red,
          Colors.red,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MenageQuizWhilePlayWidget(
            downloadedQuizModel: model,
            menageQuiz: mockCubit,
          ),
        ),
      );

      await tester.pump(); // FutureBuilder first frame
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();
      verify(() => mockCubit.setStart(111, "DOC1")).called(1);

      await tester.tap(find.byIcon(Icons.pause));
      await tester.pump();
      verify(() => mockCubit.setPause(111)).called(1);

      await tester.tap(find.byIcon(Icons.arrow_circle_right));
      await tester.pump();
      verify(() => mockCubit.setNextQuestion(111)).called(1);

      await tester.tap(find.byIcon(Icons.stop));
      await tester.pump();
      verify(() => mockCubit.setEnd(111)).called(1);
    });

    testWidgets("Wyświetla błąd i przycisk spróbuj ponownie",
        (tester) async {

      when(() => mockCubit.setInitialColors(any()))
          .thenAnswer((_) async => Future.value());

      final error = MenageQuizError(UnknownException(error:"Błąd testowy"));

      whenListen(
        mockCubit,
        Stream.fromIterable([error]),
        initialState: error,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MenageQuizWhilePlayWidget(
            downloadedQuizModel: model,
            menageQuiz: mockCubit,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining("Błąd testowy"), findsOneWidget);
      expect(find.text("Spróbuj ponownie."), findsOneWidget);

      await tester.tap(find.text("Spróbuj ponownie."));
      await tester.pump();
      verify(() => mockCubit.setInitialColors(111)).called(2);// once on init and once on button tap
    });

    testWidgets("Wyświetla CircularProgressIndicator gdy stan inny niż ButtonsColors i Error",
        (tester) async {

      when(() => mockCubit.setInitialColors(any()))
          .thenAnswer((_) async => Future.value());

      whenListen(
        mockCubit,
        Stream.fromIterable([MenageQuizInitial()]),
        initialState: MenageQuizInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MenageQuizWhilePlayWidget(
            downloadedQuizModel: model,
            menageQuiz: mockCubit,
          ),
        ),
      );

      await tester.pump(); // FutureBuilder
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
