import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/auth_repository.dart';
import '../validation/login.dart';
import '../validation/password.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  Email email = const Email.pure();
  Password password = const Password.pure();
  StreamSubscription<User?>? streamA;

  void emailChanged(String value) {
    email = Email.dirty(value);
    emit(AuthFieldsChanged(email, password));
  }

  void passwordChanged(String value) {
    password = Password.dirty(value);
    emit(AuthFieldsChanged(email, password));
  }

  void clearFields() {
    email = const Email.pure();
    password = const Password.pure();
    emit(const AuthInitial());
  }

  Future<void> login() async {
    if (!email.isValid || !password.isValid) {
      emit(const AuthFailure("Zostały podane nieprawidłowe dane."));
      return;
    }

    emit(const AuthLoading());
    final result = await _authRepository.login(email.value, password.value);
    result.fold(
      (error) => emit(AuthFailure(error.toString())),
      (_) {} );
  }

  Future<void> register() async {
    if (!email.isValid || !password.isValid) {
      emit(const AuthFailure("Zostały podane nieprawidłowe dane."));
      return;
    }

    emit(const AuthLoading());
    final result =
        await _authRepository.register(email.value, password.value);
    result.fold((error) => emit(AuthFailure(error.toString())), (user) async {
      final addUserResoult = await _authRepository.addUserToDB(user);
      addUserResoult.fold((left) {
        emit(AuthFailure(left.toString()));
      }, (_) {});
    });
  }

  Future<void> userIsVerified() async {
    final response = await _authRepository.isUserVerified();
    response.fold((error) {
      emit(AuthFailure(error.toString()));
    }, (right) {
      right
          ? emit(AuthUserIsVerified(true, _authRepository.user))
          : emit(AuthUserIsNotVerified(false, _authRepository.user));
    });
  }

  Future<void> loginAnonymous() async {
    emit(const AuthLoading());
    final result = await _authRepository.loginAnonymous();
    result.fold(
      (error) => emit(AuthFailure(error.toString())),
      (_){});
  }

  Future<void> changePassword() async {
  final _email = email.value; // Pobranie aktualnego emaila

  if (_email.isEmpty || !email.isValid) {
    emit(const AuthFailure("Email jest nieprawidłowy"));
    return;
  }

  emit(const AuthLoading());

  try {
    await _authRepository.changePassword(_email);
    emit(const PasswordChanged());
  } catch (e) {
    emit(AuthFailure("Błąd podczas resetowania hasła: ${e.toString()}"));
  }
}

  void isLogged() {
    streamA?.cancel();
    final userStream = _authRepository.streamUser;
    streamA = 
    userStream.listen((data){
     if (data != null) {
      if(data.isAnonymous){
        emit(AuthAnonimSuccess(data));
      }else{
        emit(AuthSuccess(data));
      } 
    } else{
      emit(const AuthInitial());
    } 
    });  
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    await _authRepository.logout();
    emit(const AuthInitial());
  }

  @override
  Future<void> close() {
    streamA?.cancel();
    return super.close();
  }
}
