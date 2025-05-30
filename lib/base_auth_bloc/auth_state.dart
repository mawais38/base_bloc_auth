part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthInProgress extends AuthState {}

class AuthSuccess extends AuthState {
  final dynamic user;
  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
