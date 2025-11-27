import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/quiz_module/write_code/cubit/game_code_cubit.dart';
import 'package:quiztale/quiz_module/write_code/presentation/write_code.dart';
import 'package:quiztale/quiz_module/write_nick/presentation/write_nick.dart';

class MockGameCodeCubit extends Mock implements GameCodeCubit {}

void main() {
  late MockGameCodeCubit gameCodeCubit;
  late Widget testWidget;
  setUp(() {
    gameCodeCubit = MockGameCodeCubit();
    when(() => gameCodeCubit.state).thenReturn(GameCodeInitial());
    when(() => gameCodeCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => gameCodeCubit.close()).thenAnswer((_) async {});
    testWidget = MaterialApp(
      home: GameCodeScreen(
        cubit: gameCodeCubit,
      ),
    );
  });
  tearDown(() {
    gameCodeCubit.close();
  });
  group('write code', () {
    testWidgets('pokaż ekran WriteCode', (tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Wpisynanie kodu gry'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Kod gry'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Wpisynanie kodu gry'), findsOneWidget);
    });

    testWidgets('wpisz kod gry', (tester) async {
      when(() => gameCodeCubit.gameCodeChanged(any())).thenReturn(null);
      await tester.pumpWidget(testWidget);
      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      const testGameCode = 'TEST123';
      await tester.enterText(textFieldFinder, testGameCode);
      verify(() => gameCodeCubit.gameCodeChanged(testGameCode)).called(1);
    });

    testWidgets('wyświetl błąd', (tester) async {
      const errorMessage = 'Nieprawidłowy kod gry';
      when(() => gameCodeCubit.state)
          .thenReturn(GameCodeError(UnknownException(error: errorMessage)));
    
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(tester.widget<TextField>(find.byType(TextField)).decoration?.errorText, errorMessage);
    });

    testWidgets('nawiguj do NicknameScreen po sukcesie', (tester) async {
      const testGameCode = 123456;
      const testUserId = 'user123';
      const testQuizId = 'quiz123';
      whenListen(
        gameCodeCubit,
        Stream.fromIterable([
          GameCodeSuccess(testGameCode, testUserId, testQuizId),
        ]),
        initialState: GameCodeInitial(),
      );
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(NicknameScreen), findsOneWidget);
    });
  });

  testWidgets('początkowy stan nie pokazuje błędu', (tester) async {
    await tester.pumpWidget(testWidget);
    expect(
        tester.widget<TextField>(find.byType(TextField)).decoration?.errorText,
        isNull);
  });

  testWidgets('wywołuje gaemCodeSubmited po naciśnięciu przycisku', (tester) async {
    when(()=> gameCodeCubit.state).thenReturn(GameCodeChanges('gameCodeString'));
    when(() => gameCodeCubit.submitGameCode('gameCodeString')).thenAnswer((_) async {});
    await tester.pumpWidget(testWidget);
    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    verify(() => gameCodeCubit.submitGameCode('gameCodeString')).called(1);
  });
}
