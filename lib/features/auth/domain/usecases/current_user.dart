import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/auth/domain/entities/user.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository _authRepository;
  const CurrentUser(this._authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await _authRepository.currentUser();
  }
}
