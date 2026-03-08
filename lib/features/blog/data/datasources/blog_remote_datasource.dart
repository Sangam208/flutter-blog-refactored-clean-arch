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
}

class BlogRemoteDatasourceImplementation implements BlogRemoteDatasource {
  final SupabaseClient _supabaseClient;
  BlogRemoteDatasourceImplementation(this._supabaseClient);

  // Add Blog To Supabase
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await _supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  // Add Blog Image To Supabase Storage
  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog}) async {
    try {
      final storage = _supabaseClient.storage.from('blog_images');
      await storage.upload(
        blog.id,
        image,
      );
      return storage.getPublicUrl(blog.id);
    } catch (e) {
      throw ServerExceptions(e.toString());
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
            (blog) => BlogModel.fromJson(blog).copyWith(
              username: blog['profiles']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
