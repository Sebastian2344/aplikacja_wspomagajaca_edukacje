import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiztale/login_and_register_module/validation/password.dart';

import '../validation/login.dart';

sealed class AuthState extends Equatable{
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

final class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object?> get props => [];
}

final class AuthSuccess extends AuthState {
  final User? user;

  @override
  List<Object?> get props => [user];

  const AuthSuccess(this.user);
}

final class AuthFieldsChanged extends AuthState{
  final Email email;
  final Password password;

  @override
  List<Object?> get props => [email,password];

  const AuthFieldsChanged(this.email,this.password);
}

final class AuthFailure extends AuthState {
  final String error;

  @override
  List<Object?> get props => [error];

  const AuthFailure(this.error);
}

final class AuthAnonimSuccess extends AuthState {
  final User? user;

  @override
  List<Object?> get props => [user];

  const AuthAnonimSuccess(this.user);
}

final class PasswordChanged extends AuthState {
  const PasswordChanged();

  @override
  List<Object?> get props => [];
}

final class AuthUserIsVerified extends AuthState {
  final bool isVerified;
  final User? user;

  @override
  List<Object?> get props => [isVerified,user];

  const AuthUserIsVerified(this.isVerified,this.user);
}

final class AuthUserIsNotVerified extends AuthState {
  final bool isVerified;
  final User? user;
  
  @override
  List<Object?> get props => [isVerified,user];

  const AuthUserIsNotVerified(this.isVerified,this.user);
}