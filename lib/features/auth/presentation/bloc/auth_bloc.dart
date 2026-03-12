import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:my_app/core/network/connection_checker.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/core/entities/user.dart';
import 'package:my_app/features/auth/domain/usecases/current_user.dart';
import 'package:my_app/features/auth/domain/usecases/user_login.dart';
import 'package:my_app/features/auth/domain/usecases/user_logout.dart';
import 'package:my_app/features/auth/domain/usecases/user_signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserLogout _userLogout;
  final ConnectionChecker _connectionChecker;

  late final StreamSubscription<void> _logoutSubscription;

  AuthBloc({
    required UserSignup userSignup,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserLogout userLogout,
    required ConnectionChecker connectionChecker,
  })  : _userSignup = userSignup,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _userLogout = userLogout,
        _connectionChecker = connectionChecker,
        super(AuthInitial()) {
    on<AuthEvent>(
      (_, emit) => emit(AuthLoading()),
    );
    on<AuthSignUp>(_onAuthSignup);
    on<AuthLogin>(_onAuthLogin);
    on<AuthCurrentUser>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);

    _logoutSubscription = _appUserCubit.logoutRequested.listen(
      (_) => add(AuthLogout()),
    );
  }

  @override
  Future<void> close() async {
    await _logoutSubscription.cancel();
    await super.close();
  }

  // AuthSignUp Implementation
  void _onAuthSignup(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignup(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  // AuthLogin Implementation
  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  // AuthLogout Implementation
  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    if (!await (_connectionChecker.isConnected)) {
      emit(AuthFailure('No Internet Connection'));
    }
    final res = await _userLogout(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        _appUserCubit.updateUserStatus(null);
        emit(AuthInitial());
      },
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
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUserStatus(user);
    emit(AuthSuccess(user));
  }
}
