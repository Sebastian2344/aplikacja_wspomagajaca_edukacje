import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:quiztale/quiz_module/commons/exceptions/exceptions.dart';
import 'package:quiztale/quiz_module/write_nick/cubit/write_nick_cubit.dart';

void main(){
  group('WriteNickCubit', () {
    late WriteNickCubit writeNickCubit;

    setUp(() {
      writeNickCubit = WriteNickCubit();
    });

    tearDown(() {
      writeNickCubit.close();
    });

    test('initial state is WriteNickInitial', () {
      expect(writeNickCubit.state, WriteNickInitial());
    });

    blocTest<WriteNickCubit, WriteNickState>(
      'emits [WriteNickValid] when valid nickname is entered',
      build: () => writeNickCubit,
      act: (cubit) => cubit.submitNickname('ValidNick'),
      expect: () => [isA<WriteNickSuccess>().having((e)=>e.nickname, 'nickname', 'ValidNick')],
    );

    blocTest<WriteNickCubit, WriteNickState>(
      'emits [WriteNickInvalid] when invalid nickname is entered',
      build: ()=> writeNickCubit,
      act: (cubit) => cubit.submitNickname('hh123!@#'),
      expect: () => [isA<WriteNickError>().having((e)=>e.error, 'error', isA<UnknownException>().having((e)=> e.error, 'error', 'Niepoprawna nazwa użytkownika. Możesz tylko wpisywać litery i cyfry.'))],
    );

  blocTest<WriteNickCubit, WriteNickState>(
    'emits [WriteNickChanges] when nickname is changed.',
    build: ()=> writeNickCubit,
    act: (bloc) => bloc.nicknameChanged('nickname1'),
    expect: () => [isA<WriteNickChanges>().having((e) => e.nickname, 'nickname', 'nickname1')],
  );

  blocTest<WriteNickCubit, WriteNickState>(
      'emits [WriteNickInvalid] when invalid nickname is too short',
      build: ()=> writeNickCubit,
      act: (cubit) => cubit.submitNickname('hh'),
      expect: () => [isA<WriteNickError>().having((e)=>e.error, 'error', isA<UnknownException>().having((e)=> e.error, 'error', 'Zła długość nazwy użytkownika'))],
    );

  });
}