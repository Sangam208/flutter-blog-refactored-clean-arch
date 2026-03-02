import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/blog/domain/entities/blog.dart';
import 'package:my_app/features/blog/domain/repositories/blog_repository.dart';

class UploadBlog implements Usecase<Blog, BlogParams> {
  final BlogRepository blogRepository;
  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(BlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      userId: params.userId,
    );
  }
}

class BlogParams {
  final String userId;
  final String title;
  final String content;
  final File image;

  BlogParams({
    required this.userId,
    required this.title,
    required this.content,
    required this.image,
  });
}
