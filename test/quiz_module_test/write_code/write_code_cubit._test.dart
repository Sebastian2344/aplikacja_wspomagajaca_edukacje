import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/quiz_module/write_code/cubit/game_code_cubit.dart';
import 'package:quiztale/quiz_module/write_code/data/gamecode_repo.dart/gamecode_repo.dart';

class MockGameCodeRepo extends Mock implements GameCodeRepo {}

void main() {
  late MockGameCodeRepo mockGameCodeRepo;
  late GameCodeCubit gameCodeCubit;
  setUp(() {
    mockGameCodeRepo = MockGameCodeRepo();
    gameCodeCubit = GameCodeCubit(mockGameCodeRepo);
  });
  tearDown(() {
    gameCodeCubit.close();
  });
  group('group name', () {
    test('initial state is GameCodeInitial', () {
      expect(gameCodeCubit.state, equals(GameCodeInitial()));
    });

    blocTest<GameCodeCubit, GameCodeState>(
      'emits [GameCodeChanges] when gameCodeChanged is call.',
      build: () => gameCodeCubit,
      act: (bloc) => bloc.gameCodeChanged('ABC123'),
      expect: () => [
        isA<GameCodeChanges>().having((e) => e.gameCode, 'gamecode', 'ABC123')
      ],
    );

    blocTest<GameCodeCubit, GameCodeState>(
      'emits [GameCodeSuccess] when submitGameCode is successful.',
      build: () {
        when(() => mockGameCodeRepo.isQuizExist(123456)).thenAnswer((_) async {
          return const Right(('quizId', true, 'userId'));
        });
        return gameCodeCubit;
      },
      act: (bloc) => bloc.submitGameCode('123456'),
      expect: () => [
        isA<GameCodeSuccess>()
            .having((e) => e.gameCode, 'kod gry', 123456)
            .having((e) => e.quizId, 'id quizu', 'quizId')
            .having((e) => e.userId, 'userId', 'userId')
      ],
    );

    blocTest<GameCodeCubit, GameCodeState>(
      'emits [GameCodeFailure] when submitGameCode fails bad code.',
      build: () {
        when(() => mockGameCodeRepo.isQuizExist(any())).thenAnswer((_) async {
          return Left(UnknownException(
              error: 'Niepoprawny kod. Możesz tylko wpisywać cyfry.'));
        });
        return gameCodeCubit;
      },
      act: (bloc) => bloc.submitGameCode('ABC123'),
      expect: () => [
        isA<GameCodeError>().having((e) => e.error.error, 'komunikat błędu',
            'Niepoprawny kod. Możesz tylko wpisywać cyfry.')
      ],
    );

    blocTest<GameCodeCubit, GameCodeState>(
      'emits [GameCodeFailure] when submitGameCode fails too short code.',
      build: () {
        when(() => mockGameCodeRepo.isQuizExist(any())).thenAnswer((_) async {
          return Left(UnknownException(error: 'Kod gry musi mieć 6 cyfr'));
        });
        return gameCodeCubit;
      },
      act: (bloc) => bloc.submitGameCode(''),
      expect: () => [
        isA<GameCodeError>().having(
            (e) => e.error.error, 'komunikat błędu', 'Kod gry musi mieć 6 cyfr')
      ],
    );

    blocTest<GameCodeCubit, GameCodeState>(
      'emits [GameCodeFailure] when submitGameCode fails.',
      build: () {
        when(() => mockGameCodeRepo.isQuizExist(any())).thenAnswer((_) async {
          return Left(NetworkException(error: 'Nie ma'));
        });
        return gameCodeCubit;
      },
      act: (bloc) => bloc.submitGameCode('123456'),
      expect: () => [
        isA<GameCodeError>().having((e) => e.error.error, 'komunikat błędu', 'Nie ma')
      ],
    );
  });
}
