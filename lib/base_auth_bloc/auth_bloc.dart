import 'package:base_bloc_auth/data/auth_services.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({
    AuthService? authService,
  })  : authService = authService ?? AuthService(),
        super(AuthInitial()) {
    on<LoginButtonPressed>(_handleLogin);
    on<SignUpButtonPressed>(_handleSignUp);
    on<AuthStarted>(_handleAuthStarted);
    // on<VerifyEmailButtonPressed>(_handleVerifyEmail);
  }

  ///
  /// Auth started at the start of app
  ///
  Future<void> _handleAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AuthFailure(error: ''));
        return;
      }
      final userData = await AuthService().getCurrentUserData(event.collectionName);
      emit(AuthSuccess(user: userData));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  ///
  /// handle login
  ///
  Future<void> _handleLogin(LoginButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());

    try {
      final userData = await authService.signInWithEmail(
        email: event.username,
        password: event.password,
        collectionName: event.collectionName,
      );
      emit(AuthSuccess(user: userData));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  ///
  /// hanlde signup
  ///
  Future<void> _handleSignUp(SignUpButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());

    try {
      final newUser = await authService.signUpWithEmail(
        email: event.email,
        password: event.password,
        userData: event.userData,
        collectionName: event.collectionName,
      );

      emit(AuthSuccess(user: newUser));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
