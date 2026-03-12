import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/blog/domain/repositories/blog_repository.dart';

class ClearLocalBlogs implements Usecase<void, NoParams> {
  final BlogRepository _blogRepository;
  ClearLocalBlogs(this._blogRepository);

  @override
  Future<Either<Failure, void>> call(params) async {
    await _blogRepository.clearLocalBlogs();
    return right(null);
  }
}
