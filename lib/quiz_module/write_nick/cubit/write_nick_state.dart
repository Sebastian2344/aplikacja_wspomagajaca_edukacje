part of 'write_nick_cubit.dart';

sealed class WriteNickState extends Equatable {
  const WriteNickState();

  @override
  List<Object> get props => [];
}

final class WriteNickInitial extends WriteNickState {}
final class WriteNickError extends WriteNickState {
  const WriteNickError(this.error);
  final Exceptions error;
  @override
  List<Object> get props => [error];
}

final class WriteNickChanges extends WriteNickState {
  const WriteNickChanges(this.nickname);
  final String nickname;
  @override
  List<Object> get props => [nickname];
}

final class WriteNickSuccess extends WriteNickState {
  const WriteNickSuccess(this.nickname);
  final String nickname;
  @override
  List<Object> get props => [nickname];
}