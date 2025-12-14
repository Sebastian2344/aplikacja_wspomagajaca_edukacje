import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/timer_cubit.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  group('TimerCubit', () {
    test('initial state is TimerInitial', () {
      final cubit = TimerCubit();
      expect(cubit.state, isA<TimerInitial>());
    });

    test('startTimer sets remaining time correctly', () {
      final cubit = TimerCubit();
      cubit.startTimer(5);
      expect(cubit.reamingTime, 5);
    });

    blocTest<TimerCubit, TimerState>(
      'emits TimerRunning states and finally TimerCompleted',
      build: () => TimerCubit(),
      act: (cubit) {
        fakeAsync((async) {
          cubit.startTimer(3);
          async.elapse(const Duration(seconds: 4));
        });
      },
      expect: () => [
        TimerRunning(3),
        TimerRunning(2),
        TimerRunning(1),
        TimerRunning(0),
        const TimerCompleted(),
      ],
    );


      blocTest<TimerCubit, TimerState>(
        'stopTimer stops the timer and emits TimerStopped',
        build: () => TimerCubit(),
        act: (cubit) {
          cubit.startTimer(5);
          cubit.stopTimer();
        },
        expect: () => [
          TimerRunning(5),
          isA<TimerStopped>(),
        ],
        verify: (cubit) {
          expect(cubit.reamingTime, 5);
        },
      );

    blocTest<TimerCubit, TimerState>(
      'startCheckingAnswerTimer starts a 10-second timer',
      build: () => TimerCubit(),
      act: (cubit) {
        fakeAsync((async) {
          cubit.startCheckingAnswerTimer(); // calls startTimer(10)
          async.elapse(const Duration(seconds: 3));
        });
      },
      expect: () => [
        TimerRunning(10),
        TimerRunning(9),
        TimerRunning(8),
        TimerRunning(7),
      ],
      verify: (cubit) {
        expect(cubit.isCheckingAnswer, true);
      },
    );
  });
}
