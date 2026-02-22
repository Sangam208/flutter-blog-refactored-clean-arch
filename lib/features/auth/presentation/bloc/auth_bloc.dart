import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_app/features/auth/domain/entities/user.dart';
import 'package:my_app/features/auth/domain/usecases/user_signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;

  AuthBloc({required UserSignup userSignup})
      : _userSignup = userSignup,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      final res = await _userSignup.call(UseCaseParams(
          name: event.name, email: event.email, password: event.password));
      res.fold(
        (l) => emit(AuthFailure(l.message)),
        (r) => emit(
          AuthSuccess(r),
        ),
      );
    });
  }
}
