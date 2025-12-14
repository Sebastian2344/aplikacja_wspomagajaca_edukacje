import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiztale/quiz_module/quiz_game/cubit/user_answer_cubit.dart';

void main(){
  late final UserAnswerCubit userAnswerCubit;
  setUp((){
    userAnswerCubit = UserAnswerCubit();
  });

  blocTest('initStateUserAnswer()', build: () => userAnswerCubit,
    act: (cubit) => cubit.initStateUserAnswer(),
    expect: () => [const UserAnswerInitial()],
  );

  blocTest('setCheckIconAnswer()', build: () => userAnswerCubit,
    act: (cubit) => cubit.setCheckIconAnswer('A', ['A','B','C','D']),
    expect: () => [isA<UserAnswerIcon>()],
    verify: (cubit) {
      final state = cubit.state;
      if (state is UserAnswerIcon) {
        expect(state.icon[0]?.icon, Icons.check_circle_outline);
        expect(state.icon[1]?.icon, Icons.circle_outlined);
        expect(state.icon[2]?.icon, Icons.circle_outlined);
        expect(state.icon[3]?.icon, Icons.circle_outlined);
      } else {
        fail('State is not UserAnswerIcon');
      }
    },
  );

  test('lastChoice()', (){
    userAnswerCubit.setCheckIconAnswer('B', ['A','B','C','D']);
    expect(userAnswerCubit.lastChoice(), 'B');
  });
}