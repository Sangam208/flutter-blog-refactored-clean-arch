import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/features/blog/domain/entities/blog.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String userId,
  });
  Future<Either<Failure, List<Blog>>> fetchBlogs();

  Future<void> clearLocalBlogs();
}
