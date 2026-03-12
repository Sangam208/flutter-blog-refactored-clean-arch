import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/entities/user.dart';

abstract interface class AuthRepository {
  // Sign Up Method
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  // Log In Method
  Future<Either<Failure, User>> logInWithEmailPassword({
    required String email,
    required String password,
  });

  // Current User Method
  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, void>> logOut();
}
