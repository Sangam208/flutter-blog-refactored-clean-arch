import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:fpdart/fpdart.dart';
import 'package:my_app/core/error/exceptions.dart';
import 'package:my_app/core/error/failure.dart';
import 'package:my_app/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:my_app/features/blog/data/models/blog_model.dart';
import 'package:my_app/features/blog/domain/entities/blog.dart';
import 'package:my_app/features/blog/domain/repositories/blog_repository.dart';

class BlogRepositoryImplementation implements BlogRepository {
  final BlogRemoteDatasource _blogRemoteDatasource;
  BlogRepositoryImplementation(this._blogRemoteDatasource);

  // Add Blog Implementation
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String userId,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        userId: userId,
        title: title,
        content: content,
        imageUrl: '',
        updatedAt: DateTime.now(),
      );

      final imageUrl = await _blogRemoteDatasource.uploadBlogImage(
          image: image, blog: blogModel);

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final blog = await _blogRemoteDatasource.uploadBlog(blogModel);

      return right(blog);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> fetchBlogs() async {
    try {
      final blogs = await _blogRemoteDatasource.fetchBlogs();
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
