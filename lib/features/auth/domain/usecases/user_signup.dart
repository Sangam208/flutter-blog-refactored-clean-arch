import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/auth/domain/entities/user.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';

class UserSignup implements Usecase<User, UseCaseParams> {
  AuthRepository authRepository;
  UserSignup(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UseCaseParams params) async {
    return await authRepository.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UseCaseParams {
  final String name;
  final String email;
  final String password;
  UseCaseParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
