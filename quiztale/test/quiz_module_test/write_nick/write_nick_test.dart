import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/quiz_module/write_nick/cubit/write_nick_cubit.dart';
import 'package:quiztale/quiz_module/write_nick/presentation/write_nick.dart';

class MockWriteNickCubit extends Mock implements WriteNickCubit {}

void main() {
  late MockWriteNickCubit writeNickCubit;
  late Widget testWidget;

  setUp(() {
    writeNickCubit = MockWriteNickCubit();
    when(() => writeNickCubit.state).thenReturn(WriteNickInitial());
    when(() => writeNickCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => writeNickCubit.close()).thenAnswer((_) async {});

    testWidget = MaterialApp(
      home: NicknameScreen(
        gameCode: 1234,
        quizId: 'quiz1',
        quizOwnerId: 'owner1',
        cubit: writeNickCubit,
      ),
    );
  });

  tearDown(() {
    writeNickCubit.close();
  });

  group('WriteNickScreen', () {
    testWidgets('renders NicknameScreen', (tester) async {
      await tester.pumpWidget(testWidget);

      expect(find.byType(NicknameScreen), findsOneWidget);
      expect(find.text('Ustawiane nazwy gracza'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows error message when WriteNickError emitted',
        (tester) async {
      final errorState = WriteNickError(
        UnknownException(error: 'Test error'),
      );

      // UI przebuduje się tylko przez stream!
      when(() => writeNickCubit.state).thenReturn(errorState);
      when(() => writeNickCubit.stream)
          .thenAnswer((_) => Stream.value(errorState));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(
          tester
              .widget<TextField>(find.byType(TextField))
              .decoration
              ?.errorText,
          'Test error');
    });

    testWidgets('navigates to QuizScreen on WriteNickSuccess', (tester) async {
      final successState = WriteNickSuccess('ValidNick');

      when(() => writeNickCubit.state).thenReturn(WriteNickInitial());
      when(() => writeNickCubit.stream)
          .thenAnswer((_) => Stream.fromIterable([WriteNickInitial(), successState]));

      await tester.pumpWidget(testWidget);

      expect(find.byType(NicknameScreen), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(NicknameScreen), findsNothing);
    });

    testWidgets('calls nicknameChanged on text input', (tester) async {
      when(() => writeNickCubit.nicknameChanged(any())).thenReturn(null);

      await tester.pumpWidget(testWidget);

      await tester.enterText(find.byType(TextField), 'NewNick');
      await tester.pump();

      verify(() => writeNickCubit.nicknameChanged('NewNick')).called(1);
    });

    testWidgets('shows no error message on initial state', (tester) async {
      await tester.pumpWidget(testWidget);

      expect(
          tester
              .widget<TextField>(find.byType(TextField))
              .decoration
              ?.errorText,
          isNull);
    });
  });
}
