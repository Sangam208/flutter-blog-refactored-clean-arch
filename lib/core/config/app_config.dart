import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get projectUri => dotenv.env['PROJECT_URI']!;
  static String get anonKey => dotenv.env['ANON_KEY']!;
}
