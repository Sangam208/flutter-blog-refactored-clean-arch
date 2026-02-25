import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/auth/domain/entities/user.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';

class UserSignup implements Usecase<User, UserSignUpParams> {
  final AuthRepository _authRepository;
  const UserSignup(this._authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await _authRepository.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;
  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
