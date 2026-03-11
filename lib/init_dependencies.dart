import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_app/core/config/app_config.dart';
import 'package:my_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:my_app/core/network/connection_checker.dart';
import 'package:my_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_app/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_app/features/auth/domain/usecases/current_user.dart';
import 'package:my_app/features/auth/domain/usecases/user_login.dart';
import 'package:my_app/features/auth/domain/usecases/user_signup.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_app/features/blog/data/datasources/blog_local_datasource.dart';
import 'package:my_app/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:my_app/features/blog/data/repositories/blog_repository_implementation.dart';
import 'package:my_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:my_app/features/blog/domain/usecases/fetch_blogs.dart';
import 'package:my_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:my_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Supabase Initialization
  final supabase = await Supabase.initialize(
    url: AppConfig.projectUri,
    anonKey: AppConfig.anonKey,
  );

  // Hive Initialization
  Hive.init((await getApplicationDocumentsDirectory()).path);
  final blogsBox = await Hive.openBox('blogs');

  // Supabase Registration
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );

  // Hive Registration
  serviceLocator.registerLazySingleton(
    () => blogsBox,
  );

  // core stuff
  // AppUserCubit Registration
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  // InternetConnection Registration
  serviceLocator.registerFactory(
    () => InternetConnection(),
  );

  // ConnectionChecker Registration
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImplementation(
      serviceLocator(),
    ),
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

    // Blog Local Data Source (H I V E)
    ..registerFactory<BlogLocalDatasource>(
      () => BlogLocalDatasourceImplementation(
        serviceLocator(),
      ),
    )

    // Blog Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImplementation(
        serviceLocator(),
        serviceLocator(),
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
