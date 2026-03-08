import 'package:get_it/get_it.dart';
import 'package:my_app/core/config/app_config.dart';
import 'package:my_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:my_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_app/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_app/features/auth/domain/usecases/current_user.dart';
import 'package:my_app/features/auth/domain/usecases/user_login.dart';
import 'package:my_app/features/auth/domain/usecases/user_signup.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_app/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:my_app/features/blog/data/repositories/blog_repository_implementation.dart';
import 'package:my_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:my_app/features/blog/domain/usecases/fetch_blogs.dart';
import 'package:my_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:my_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Supabase Initialization
  final supabase = await Supabase.initialize(
    url: AppConfig.projectUri,
    anonKey: AppConfig.anonKey,
  );

  // Supabase Registration
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );

  // AppUserCubit Registration
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  _initAuth();
  _initBlog();
}

void _initAuth() {
  // Auth Remote Data Source
  serviceLocator
    ..registerFactory<AuthRemoteDatasource>(
      () => AuthRemoteDataSourceImplementation(
        serviceLocator(),
      ),
    )

    // Auth Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImplementation(
        serviceLocator(),
      ),
    )

    // Use Cases
    ..registerFactory(
      () => UserSignup(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )

    // Auth Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignup: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    // Blog Remote Data Source
    ..registerFactory<BlogRemoteDatasource>(
      () => BlogRemoteDatasourceImplementation(
        serviceLocator(),
      ),
    )

    // Blog Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImplementation(
        serviceLocator(),
      ),
    )

    // Blog Upload Usecase
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )

    // Blogs Fetch Usecase
    ..registerFactory(
      () => FetchBlogs(
        serviceLocator(),
      ),
    )

    // Blog Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        fetchBlogs: serviceLocator(),
      ),
    );
}
