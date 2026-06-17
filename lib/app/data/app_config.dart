import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl =>
      dotenv.env['FLASK_API_URL'] ?? 'http://localhost:5000/api/v1';
}
