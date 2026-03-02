import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_app/features/auth/presentation/pages/login.dart';
import 'package:my_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:my_app/features/blog/presentation/pages/add_blog.dart';
import 'package:my_app/features/blog/presentation/pages/home.dart';
import 'package:my_app/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initDependencies();
  runApp(DevicePreview(
    enabled: kReleaseMode,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<BlogBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthCurrentUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(139, 186, 236, 0.698),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(226, 251, 116, 0.694),
        ),
        primaryColor: Color.fromRGBO(193, 211, 113, 0.686),
        textTheme: TextTheme(
          titleMedium: TextStyle(
            fontFamily: 'Lato',
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Lato',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Lato',
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            fontFamily: 'Lato',
            color: Colors.black87,
          ),
        ),
      ),
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const Home();
          }
          return const Login();
        },
      ),
    );
  }
}
