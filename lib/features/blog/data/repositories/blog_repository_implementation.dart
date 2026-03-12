import 'dart:io';
import 'package:my_app/core/network/connection_checker.dart';
import 'package:my_app/features/blog/data/datasources/blog_local_datasource.dart';
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
  final BlogLocalDatasource _blogLocalDatasource;
  final ConnectionChecker _connectionChecker;

  BlogRepositoryImplementation(
    this._blogRemoteDatasource,
    this._blogLocalDatasource,
    this._connectionChecker,
  );

  // Add Blog Implementation
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String userId,
  }) async {
    try {
      if (!await _connectionChecker.isConnected) {
        return left(Failure('No Internet Connection'));
      }

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
      // Fetch from Hive if Internet Connection Missing
      if (!await _connectionChecker.isConnected) {
        final blogs = _blogLocalDatasource.loadBlogs();
        if (blogs.isEmpty) return left(Failure('No blogs found'));
        return right(blogs);
      }

      // Fetch from Supabase if Internet Connection Exists
      final blogs = await _blogRemoteDatasource.fetchBlogs();
      _blogLocalDatasource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<void> clearLocalBlogs() async {
    await _blogLocalDatasource.clearLocalBlogs();
  }
}
