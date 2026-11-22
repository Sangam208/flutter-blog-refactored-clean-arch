import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/blog/domain/repositories/blog_repository.dart';

class DeleteBlog implements Usecase<void, DeleteBlogParams> {
  final BlogRepository _blogRepository;

  DeleteBlog(this._blogRepository);

  @override
  Future<Either<Failure, void>> call(DeleteBlogParams params) {
    return _blogRepository.deleteBlog(blogId: params.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;

  const DeleteBlogParams({required this.blogId});
}
