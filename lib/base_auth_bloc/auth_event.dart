part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginButtonPressed extends AuthEvent {
  final String username;
  final String password;
  final String collectionName;

  LoginButtonPressed({
    required this.username,
    required this.password,
    required this.collectionName,
  });

  @override
  List<Object> get props => [username, password, collectionName];
}

class SignUpButtonPressed extends AuthEvent {
  final String email;
  final String password;
  final Map<String, dynamic> userData;
  final String collectionName;

  SignUpButtonPressed({
    required this.email,
    required this.password,
    required this.userData,
    required this.collectionName,
  });

  @override
  List<Object?> get props => [email, password, userData, collectionName];
}

// class AuthStarted extends AuthEvent {
//   final String collectionName;
//
//   AuthStarted({required this.collectionName});
//
//   @override
//   List<Object?> get props => [collectionName];
// }

class VerifyEmailButtonPressed extends AuthEvent {}
