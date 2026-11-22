import 'package:my_app/core/error/exceptions.dart';
import 'package:my_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDatasource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> logOut();
}

class AuthRemoteDataSourceImplementation implements AuthRemoteDatasource {
  final SupabaseClient _supabaseClient;
  AuthRemoteDataSourceImplementation(this._supabaseClient);
  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerExceptions(
          'missing signup user',
          fallback: 'Could not create your account. Please try again.',
        );
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerExceptions(
        e.message,
        fallback: 'Could not create your account. Please try again.',
      );
    } catch (e) {
      throw ServerExceptions(
        e.toString(),
        fallback: 'Could not create your account. Please try again.',
      );
    }
  }

  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerExceptions(
          'missing login user',
          fallback:
              'Could not log in. Please check your details and try again.',
        );
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerExceptions(
        e.message,
        fallback: 'Could not log in. Please check your details and try again.',
      );
    } catch (e) {
      throw ServerExceptions(
        e.toString(),
        fallback: 'Could not log in. Please try again.',
      );
    }
  }

  @override
  Session? get currentUserSession => _supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await _supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first)
            .copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerExceptions(
        e.toString(),
        fallback: 'Could not load your profile. Please sign in again.',
      );
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw ServerExceptions(
        e.message,
        fallback: 'Could not log out. Please try again.',
      );
    } catch (e) {
      throw ServerExceptions(
        e.toString(),
        fallback: 'Could not log out. Please try again.',
      );
    }
  }
}
