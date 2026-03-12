import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';

class UserLogout implements Usecase<void, NoParams> {
  final AuthRepository _authRepository;
  const UserLogout(this._authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _authRepository.logOut();
  }
}
