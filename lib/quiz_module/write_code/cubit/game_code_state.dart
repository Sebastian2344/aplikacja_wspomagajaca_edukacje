part of 'game_code_cubit.dart';

sealed class GameCodeState extends Equatable {
  const GameCodeState();

  @override
  List<Object> get props => [];
}

final class GameCodeInitial extends GameCodeState {}

final class GameCodeChanges extends GameCodeState {
  const GameCodeChanges(this.gameCode);

  final String gameCode;

  @override
  List<Object> get props => [gameCode];
}

final class GameCodeError extends GameCodeState {
  const GameCodeError(this.error);

  final Exceptions error;

  @override
  List<Object> get props => [error];
}

final class GameCodeSuccess extends GameCodeState {
  const GameCodeSuccess(this.gameCode, this.quizId,this.userId);

  final int gameCode;
  final String quizId;
  final String userId;

  @override
  List<Object> get props => [gameCode,quizId,userId];
}