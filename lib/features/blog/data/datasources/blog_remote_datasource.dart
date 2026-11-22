import 'dart:io';

import 'package:my_app/core/error/exceptions.dart';
import 'package:my_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDatasource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> fetchBlogs();
  Future<void> deleteBlog({required String blogId});
}

class BlogRemoteDatasourceImplementation implements BlogRemoteDatasource {
  final SupabaseClient _supabaseClient;
  BlogRemoteDatasourceImplementation(this._supabaseClient);

  // Add Blog To Supabase
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await _supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select();
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerExceptions(
        e.message,
        fallback: 'Could not publish your post. Please try again.',
      );
    } catch (e) {
      throw ServerExceptions(
        e.toString(),
        fallback: 'Could not publish your post. Please try again.',
      );
    }
  }

  // Add Blog Image To Supabase Storage
  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      final storage = _supabaseClient.storage.from('blog_images');
      await storage.upload(blog.id, image);
      return storage.getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerExceptions(
        e.message,
        fallback: 'Could not upload the image. Please try again.',
      );
    } catch (e) {
      throw ServerExceptions(
        e.toString(),
        fallback: 'Could not upload the image. Please try again.',
      );
    }
  }

  @override
  Future<List<BlogModel>> fetchBlogs() async {
    try {
      final blogs = await _supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .order('updated_at', ascending: false);
      return blogs
          .map(
            (blog) =>
                BlogModel.fromJson(blog)
                    .copyWith(username: blog['profiles']['name']),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerExceptions(
        e.message,
        fallback: 'Could not load posts. Please try again.',
      );
    } catch (e) {
      throw ServerExceptions(
        e.toString(),
        fallback: 'Could not load posts. Please try again.',
      );
    }
  }

  @override
  Future<void> deleteBlog({required String blogId}) async {
    try {
      await _supabaseClient.from('blogs').delete().eq('id', blogId);
    } on PostgrestException catch (e) {
      throw ServerExceptions(
        e.message,
        fallback: 'Could not delete this post. Please try again.',
      );
    } catch (e) {
      throw ServerExceptions(
        e.toString(),
        fallback: 'Could not delete this post. Please try again.',
      );
    }
  }
}
