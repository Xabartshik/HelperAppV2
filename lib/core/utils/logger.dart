import 'package:flutter/foundation.dart';

/// Простой логгер для вывода сообщений в консоль
class Logger {
  static void i(String message) {
    if (kDebugMode) {
      print('ℹ️ [INFO]: $message');
    }
  }

  static void w(String message) {
    if (kDebugMode) {
      print('⚠️ [WARNING]: $message');
    }
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('❌ [ERROR]: $message');
      if (error != null) {
        print('Error details: $error');
      }
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
  }
}
