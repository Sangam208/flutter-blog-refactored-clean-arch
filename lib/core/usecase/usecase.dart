import 'package:fpdart/fpdart.dart';

import 'package:my_app/core/error/failure.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
