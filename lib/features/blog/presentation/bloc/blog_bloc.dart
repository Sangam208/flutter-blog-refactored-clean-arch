import 'dart:async';
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/blog/domain/entities/blog.dart';
import 'package:my_app/features/blog/domain/usecases/clear_local_blogs.dart';
import 'package:my_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:my_app/features/blog/domain/usecases/fetch_blogs.dart';
import 'package:my_app/features/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final FetchBlogs _fetchBlogs;
  final DeleteBlog _deleteBlog;
  final ClearLocalBlogs _clearLocalBlogs;
  final AppUserCubit _appUserCubit;
  List<Blog> _blogs = [];

  late final StreamSubscription<AppUserState> _userSubscription;

  BlogBloc({
    required this._uploadBlog,
    required this._fetchBlogs,
    required this._deleteBlog,
    required this._clearLocalBlogs,
    required this._appUserCubit,
  }) : super(BlogInitial()) {
    on<BlogUploadRequested>(_onBlogUploadRequested);

    on<BlogFetchRequested>(_onBlogFetchRequested);

    on<BlogDeleteRequested>(_onBlogDeleteRequested);

    _userSubscription = _appUserCubit.stream.listen((state) {
      if (state is AppUserInitial) _clearLocalBlogs(NoParams());
    });
  }

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    await super.close();
  }

  void _onBlogUploadRequested(
    BlogUploadRequested event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());
    final res = await _uploadBlog(
      BlogParams(
        userId: event.userId,
        title: event.title,
        content: event.content,
        image: event.image,
      ),
    );

    res.fold((l) => emit(BlogFailure(l.message)), (r) => emit(BlogSuccess()));
  }

  void _onBlogFetchRequested(
    BlogFetchRequested event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());
    final res = await _fetchBlogs(NoParams());
    res.fold(
      (l) {
        emit(BlogFailure(l.message));
      },
      (r) {
        _blogs = r;
        emit(BlogDisplaySuccess(r));
      },
    );
  }

  void _onBlogDeleteRequested(
    BlogDeleteRequested event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _deleteBlog(DeleteBlogParams(blogId: event.blogId));

    res.fold(
      (failure) {
        emit(BlogFailure(failure.message));
        emit(BlogDisplaySuccess(_blogs));
      },
      (_) {
        _blogs = _blogs.where((blog) => blog.id != event.blogId).toList();
        emit(BlogDisplaySuccess(_blogs));
      },
    );
  }
}
