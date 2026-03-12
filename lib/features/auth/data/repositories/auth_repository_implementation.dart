import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/exceptions.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/network/connection_checker.dart';
import 'package:my_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_app/core/entities/user.dart';
import 'package:my_app/features/auth/data/models/user_model.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  final ConnectionChecker _connectionChecker;
  AuthRepositoryImplementation(
      this._authRemoteDatasource, this._connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (_connectionChecker.isConnected)) {
        final session = _authRemoteDatasource.currentUserSession;
        if (session == null) {
          return left(Failure('User not logged in!!'));
        }
        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
      final user = await _authRemoteDatasource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!!'));
      }
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> logInWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(() async => await _authRemoteDatasource
        .logInWithEmailPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await _authRemoteDatasource.signUpWithEmailPassword(
          name: name, email: email, password: password),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      if (!await (_connectionChecker.isConnected)) {
        return left(Failure('No Internet Connection'));
      }
      await _authRemoteDatasource.logOut();
      return right(null);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
