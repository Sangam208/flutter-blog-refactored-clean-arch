import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:my_app/core/usecase/usecase.dart';
import 'package:my_app/features/blog/domain/entities/blog.dart';
import 'package:my_app/features/blog/domain/usecases/clear_local_blogs.dart';
import 'package:my_app/features/blog/domain/usecases/fetch_blogs.dart';
import 'package:my_app/features/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final FetchBlogs _fetchBlogs;
  final ClearLocalBlogs _clearLocalBlogs;
  final AppUserCubit _appUserCubit;

  late final StreamSubscription<AppUserState> _userSubscription;

  BlogBloc({
    required UploadBlog uploadBlog,
    required FetchBlogs fetchBlogs,
    required ClearLocalBlogs clearLocalBlogs,
    required AppUserCubit appUserCubit,
  })  : _uploadBlog = uploadBlog,
        _fetchBlogs = fetchBlogs,
        _clearLocalBlogs = clearLocalBlogs,
        _appUserCubit = appUserCubit,
        super(BlogInitial()) {
    on<BlogEvent>((_, emit) => emit(BlogLoading()));

    on<BlogUploadRequested>(_onBlogUploadRequested);

    on<BlogFetchRequested>(_onBlogFetchRequested);

    _userSubscription = _appUserCubit.stream.listen(
      (state) {
        if (state is AppUserInitial) _clearLocalBlogs(NoParams());
      },
    );
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
    final res = await _uploadBlog(BlogParams(
      userId: event.userId,
      title: event.title,
      content: event.content,
      image: event.image,
    ));

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogSuccess()),
    );
  }

  void _onBlogFetchRequested(
    BlogFetchRequested event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _fetchBlogs(NoParams());
    res.fold(
      (l) {
        emit(BlogFailure(l.message));
      },
      (r) => emit(BlogDisplaySuccess(r)),
    );
  }
}
