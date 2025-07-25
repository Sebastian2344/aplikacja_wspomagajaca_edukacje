import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimerInitial());

  Timer? _timer;
  int _remainingTime = 0;
  int get reamingTime => _remainingTime;
  bool isCheckingAnswer = false;

  void startTimer(int duration) {
    _remainingTime = duration;
    emit(TimerRunning(_remainingTime));

    _timer?.cancel();
    _timer = null;

    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        emit(TimerRunning(_remainingTime));
      } else {
        emit(const TimerCompleted());
        timer.cancel();
      }
    });
  }

   void stopTimer() {
    _timer?.cancel();
    _timer = null;
    emit(TimerStopped(_remainingTime));
  }

  void startCheckingAnswerTimer() {
    isCheckingAnswer = true;
    startTimer(10);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}