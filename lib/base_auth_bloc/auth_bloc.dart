import 'package:base_bloc_auth/data/auth_services.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    // on<SignUpButtonPressed>(_handleSignUp);
    on<AuthStarted>(_handleAuthStarted);
    // on<VerifyEmailButtonPressed>(_handleVerifyEmail);
    on<LoginSuccessEvent>(_handleSuccess);
  }

  ///
  /// Auth started at the start of app
  ///
  Future<void> _handleAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(AuthSuccess(user: {'uid': user.uid, 'email': user.email}));
    } else {
      emit(AuthInitial());
    }
  }

  ///
  /// handle login
  ///
  Future<void> _handleLogin(LoginButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());

    try {
      // Step 1: Sign in with Firebase Auth
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.username, password: event.password);

      final uid = credential.user?.uid;
      if (uid == null) {
        emit(AuthFailure(error: "Invalid user credentials."));
        return;
      }

      // Step 2: Fetch user data from Firestore collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(event.collectionName).doc(uid).get();

      if (userDoc.exists) {
        emit(AuthSuccess(user: userDoc.data()));
      } else {
        emit(AuthFailure(error: "User document not found in Firestore."));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
