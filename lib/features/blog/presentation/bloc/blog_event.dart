part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUploadRequested extends BlogEvent {
  final String userId;
  final String title;
  final String content;
  final File image;

  BlogUploadRequested({
    required this.userId,
    required this.title,
    required this.content,
    required this.image,
  });
}

final class BlogFetchRequested extends BlogEvent {}
