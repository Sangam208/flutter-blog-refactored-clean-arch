import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/core/entities/user.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';

class UserLogin implements Usecase<User, UserLoginParams> {
  final AuthRepository _authRepository;
  const UserLogin(this._authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await _authRepository.logInWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserLoginParams {
  String email;
  String password;
  UserLoginParams({
    required this.email,
    required this.password,
  });
}
