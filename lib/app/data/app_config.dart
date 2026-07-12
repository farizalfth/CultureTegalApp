import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl {
    String url = dotenv.env['FLASK_API_URL'] ?? 'http://localhost:5000/api/v1';

    if (Platform.isAndroid &&
        (url.contains('localhost') || url.contains('127.0.0.1'))) {
      url = url
          .replaceAll('localhost', '10.0.2.2')
          .replaceAll('127.0.0.1', '10.0.2.2');
    }
    return url;
  }
}
