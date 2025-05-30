part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginButtonPressed extends AuthEvent {
  final String username;
  final String password;

  LoginButtonPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() => 'LoginButtonPressed { username: $username, password: $password }';
}

class SignUpButtonPressed extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class VerifyEmailButtonPressed extends AuthEvent {}

class LoginSuccessEvent extends AuthEvent {}
