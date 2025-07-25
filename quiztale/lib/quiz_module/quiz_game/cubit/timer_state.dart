part of 'timer_cubit.dart';

sealed class TimerState extends Equatable{
  const TimerState();
}

class TimerInitial extends TimerState {
  const TimerInitial();
  
  @override
  List<Object?> get props => [];
}

class TimerRunning extends TimerState {
  final int remainingTime;

  const TimerRunning(this.remainingTime);
  
  @override
  List<Object?> get props => [remainingTime];
}

class TimerStopped extends TimerState {
  final int remainingTime;
  const TimerStopped(this.remainingTime);
  
  @override
  List<Object?> get props => [remainingTime];
}

class TimerCompleted extends TimerState {
  const TimerCompleted();
  
  @override
  List<Object?> get props => [];
}