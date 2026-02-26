import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/exceptions.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_app/core/entities/user.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  AuthRemoteDatasource authRemoteDatasource;
  AuthRepositoryImplementation(this.authRemoteDatasource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authRemoteDatasource.getCurrentUserData();
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
    return _getUser(() async => await authRemoteDatasource
        .logInWithEmailPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await authRemoteDatasource.signUpWithEmailPassword(
          name: name, email: email, password: password),
    );
  }
}

Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
  try {
    final user = await fn();
    return right(user);
  } on ServerExceptions catch (e) {
    return left(Failure(e.message));
  }
}
