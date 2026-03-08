import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/blog/domain/entities/blog.dart';
import 'package:my_app/features/blog/domain/repositories/blog_repository.dart';

class FetchBlogs implements Usecase<List<Blog>, NoParams> {
  final BlogRepository _blogRepository;
  FetchBlogs(this._blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await _blogRepository.fetchBlogs();
  }
}
