part of 'user_answer_cubit.dart';

sealed class UserAnswerState extends Equatable{
  const UserAnswerState();
}

final class UserAnswerInitial extends UserAnswerState {
  const UserAnswerInitial();
  
  @override
  List<Object?> get props => [];
}

final class UserAnswerIcon extends UserAnswerState {
  final List<Icon?> icon;
  
  const UserAnswerIcon(this.icon);
  
  @override
  List<Object?> get props => [icon];

   
}
