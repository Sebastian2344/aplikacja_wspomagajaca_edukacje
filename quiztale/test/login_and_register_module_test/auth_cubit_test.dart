import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_cubit.dart';
import 'package:quiztale/login_and_register_module/cubit/auth_state.dart';
import 'package:quiztale/login_and_register_module/data/repository/auth_repository.dart';
import 'package:quiztale/login_and_register_module/exceptions/exceptions.dart';
import 'package:quiztale/login_and_register_module/validation/login.dart';
import 'package:quiztale/login_and_register_module/validation/password.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}
class UserMock extends Fake implements User {}

void main() {
  late final AuthCubit authCubit;
  late final AuthRepositoryMock authRepository;
  late final UserMock userMock;
  setUp(() {
    authRepository = AuthRepositoryMock();
    authCubit = AuthCubit(authRepository);
    userMock = UserMock();
  });

  tearDown(()=> authCubit.close());

  blocTest(
    'email changed',
    build: () => authCubit,
    act: (bloc) => bloc.emailChanged('v@gmail.com'),
    expect: () => [
      isA<AuthFieldsChanged>()
          .having((e) => e.email.value, 'email changed', 'v@gmail.com')
    ],
  );

   blocTest(
    'password changed',
    build: () => authCubit,
    act: (bloc) => bloc.passwordChanged('123456'),
    expect: () => [
      isA<AuthFieldsChanged>()
          .having((e) => e.password.value, 'pass changed', '123456')
    ],
  );

   blocTest(
    'login',
    build: () => authCubit,
    setUp: () {
      authCubit.email = Email.dirty('email@gmail.com');
      authCubit.password = Password.dirty('Pass123!');
      when(() => authRepository.login('email@gmail.com', 'Pass123!'),).thenAnswer((_) async => Right(null));
    } ,
    act: (bloc) => bloc.login(),
    expect: () => [isA<AuthLoading>()],
  );

  blocTest(
    'register',
    build: () => authCubit,
    setUp: () {
      authCubit.email = Email.dirty('email@gmail.com');
      authCubit.password = Password.dirty('Pass123!');
      when(() => authRepository.register('email@gmail.com', 'Pass123!'),).thenAnswer((_) async => Right(userMock));
      when(() => authRepository.addUserToDB(userMock),).thenAnswer((_) async => Right(unit));
    },
    act: (bloc) => bloc.register(),
    expect: () => [isA<AuthLoading>()],
  );

  blocTest(
    'logout',
    build: () => authCubit,
    setUp: ()=> when(() => authRepository.logout(),).thenAnswer((_) async => Right(unit)),
    act: (bloc) => bloc.logout(),
    expect: () => [isA<AuthLoading>(),isA<AuthInitial>()],
  );

  blocTest(
    'is logged',
    build: () => authCubit,
    setUp: () {
      when(() => authRepository.streamUser,).thenAnswer((_)=> Stream<UserMock>.value(userMock));
    },
    act: (bloc) => bloc.isLogged(),
    expect: () => [isA<AuthSuccess>()],
  );

  blocTest(
    'is logged anonim',
    build: () => authCubit,
    setUp: () {
      when(() => authRepository.streamUser,).thenAnswer((_)=> Stream<UserMock>.value(userMock));
    },
    act: (bloc) => bloc.isLogged(),
    expect: () => [isA<AuthAnonimSuccess>()],
  );

  blocTest(
    'login anonymous',
    build: () => authCubit,
    setUp: () => when(() => authRepository.loginAnonymous(),).thenAnswer((_) async => Right(null)),
    act: (bloc) => bloc.loginAnonymous(),
    expect: () => [isA<AuthLoading>()],
  );

  blocTest(
    'login anonymous failure',
    build: () => authCubit,
    act: (bloc) => bloc.loginAnonymous(),
    setUp: () => when(() => authRepository.loginAnonymous(),).thenAnswer((_) async => Left(AuthException(AuthError.networkRequestFailed))),
    expect: () => [isA<AuthLoading>(),isA<AuthFailure>().having((e)=> e.error, 'error', 'network-request-failed')],
  );
}
