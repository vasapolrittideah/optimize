import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimize/app.dart';

/// Entry point of the Flutter application
Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await _initializeServices();

      _configureErrorHandling();

      await _configureSystemUI();

      runApp(const App());
    },
    (error, stackTrace) {
      _reportError('Uncaught async error', error, stackTrace);
    },
  );
}

/// Initialize essential services before application launch
Future<void> _initializeServices() async {
  try {
    await sl<AppConfig>().load();

    await sl<HiveManager>().init();
  } catch (error, stackTrace) {
    _reportError('Service initialization failed', error, stackTrace);
    rethrow;
  }
}

/// Set up global error handling for Flutter and Dart errors
void _configureErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    _reportError('Flutter error', details.exception, details.stack);

    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    _reportError('Platform error', error, stack);
    return true;
  };
}

/// Configure system UI elements like status bar and navigation bar
Future<void> _configureSystemUI() async {
  try {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  } catch (error, stackTrace) {
    _reportError('System UI configuration failed', error, stackTrace);
    // Don't rethrow - app can continue without these settings
  }
}

/// Report errors to console or external service based on build mode
void _reportError(String context, Object error, StackTrace? stackTrace) {
  if (kDebugMode) {
    debugPrint('$context: $error');
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  } else {
    // Send to crash reporting service
  }
}
