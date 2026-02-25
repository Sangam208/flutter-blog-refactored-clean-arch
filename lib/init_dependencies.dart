import 'package:get_it/get_it.dart';
import 'package:my_app/core/config/app_config.dart';
import 'package:my_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_app/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_app/features/auth/domain/usecases/current_user.dart';
import 'package:my_app/features/auth/domain/usecases/user_login.dart';
import 'package:my_app/features/auth/domain/usecases/user_signup.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppConfig.projectUri,
    anonKey: AppConfig.anonKey,
  );
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );
  _initAuth();
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
      ),
    );
}
