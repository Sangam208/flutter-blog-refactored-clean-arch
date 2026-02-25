import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/auth/domain/entities/user.dart';
import 'package:my_app/features/auth/domain/usecases/current_user.dart';
import 'package:my_app/features/auth/domain/usecases/user_login.dart';
import 'package:my_app/features/auth/domain/usecases/user_signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;

  AuthBloc(
      {required UserSignup userSignup,
      required UserLogin userLogin,
      required CurrentUser currentUser})
      : _userSignup = userSignup,
        _userLogin = userLogin,
        _currentUser = currentUser,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignup);
    on<AuthLogin>(_onAuthLogin);
    on<AuthCurrentUser>(_isUserLoggedIn);
  }

  // AuthSignUp Implementation
  void _onAuthSignup(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignup(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(
        AuthSuccess(r),
      ),
    );
  }

  // AuthLogin Implementation
  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(
        AuthSuccess(r),
      ),
    );
  }

  // Current User Implementation
  void _isUserLoggedIn(
    AuthCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        debugPrint(r.email);
        // debugPrint(r.name);
        emit(AuthSuccess(r));
      },
    );
  }
}
