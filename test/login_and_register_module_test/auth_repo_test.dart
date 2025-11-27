import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiztale/login_and_register_module/data/data_source/auth_source.dart';
import 'package:quiztale/login_and_register_module/data/repository/auth_repository.dart';

class AuthSourceMock extends Mock implements FirebaseAuthDataSource {}
class FakeUser extends Mock implements User {}
void main(){

  late AuthRepository authRepository;
  late AuthSourceMock authSourceMock;
  late FakeUser fakeUser;

  setUp((){
    authSourceMock = AuthSourceMock();
    authRepository = AuthRepository(authSourceMock);
    fakeUser = FakeUser();
  });

  test('addUserToDB',() async {
    when(() => authSourceMock.addUserToDB(fakeUser, any<Map<String,dynamic>>()),).thenAnswer((_) async {});
    final a = await authRepository.addUserToDB(fakeUser);
    expect(a, isA<Right>());
    verify(() => authSourceMock.addUserToDB(fakeUser, any<Map<String,dynamic>>()),).called(1);
  });

  test('changePassword',() async {
    when(() => authSourceMock.changePassword(any()),).thenAnswer((_) async {});
    final a = await authRepository.changePassword('123456');
    expect(a, isA<Right>());
    verify(() => authSourceMock.changePassword(any())).called(1);
  });

  test('isVerifiedUser',() async {
    when(() => authSourceMock.isVerifiedUser(),).thenAnswer((_) async => true);
    final a = await authRepository.isUserVerified();
    expect(a, Right(true));
    verify(() => authSourceMock.isVerifiedUser(),).called(1);
  });

  test('isVerifiedUser false',() async {
    when(() => authSourceMock.isVerifiedUser(),).thenAnswer((_) async => false);
    final a = await authRepository.isUserVerified();
    expect(a, Right(false));
    verify(() => authSourceMock.isVerifiedUser(),).called(1);
  });

  test('login',() async {
    when(() => authSourceMock.login(any(), any()),).thenAnswer((_) async {});
    final a = await authRepository.login('email', 'password');
    expect(a, isA<Right>());
    verify(() => authSourceMock.login(any(), any()),).called(1);
  });

  test('loginAnonymous',() async {
    when(() => authSourceMock.loginAnonymous(),).thenAnswer((_) async {});
    final a = await authRepository.loginAnonymous();
    expect(a, isA<Right>());
    verify(() => authSourceMock.loginAnonymous(),).called(1);
  });

  test('logout',() async {
    when(() => authSourceMock.logout(),).thenAnswer((_) async {});
    final a = await authRepository.logout();
    expect(a, isA<Right>());
    verify(() => authSourceMock.logout(),).called(1);
  });

  test('register',() async {
    when(() => authSourceMock.register(any(), any()),).thenAnswer((_) async => null);
    final a = await authRepository.register('email', 'password');
    expect(a, Right(fakeUser));
    verify(() => authSourceMock.register(any(), any()),).called(1);
  });

  test('login error',() async {
    when(() => authSourceMock.login(any<String>(), any<String>()),).thenThrow(Exception());
    final a = await authRepository.login('email', 'password');
    expect(a, isA<Left>());
    verify(() => authSourceMock.login(any<String>(), any<String>()),).called(1);
  });

  test('loginAnonymous error',() async {
    when(() => authSourceMock.loginAnonymous(),).thenThrow(Exception('dupa'));
    final a = await authRepository.loginAnonymous();
    expect(a, isA<Left>());
    verify(() => authSourceMock.loginAnonymous(),).called(1);
  });
  test('register error',() async {
    when(() => authSourceMock.register(any(), any()),).thenThrow(FirebaseAuthException(code: 'invalid-email'));
    final a = await authRepository.register('email', 'password');
    expect(a, isA<Left>());
    final b = a.fold((l) => l,(r)=> {});
    expect(b.toString(),'Nieprawidłowy adres e-mail.');
    verify(() => authSourceMock.register(any(), any()),).called(1);
  });
}