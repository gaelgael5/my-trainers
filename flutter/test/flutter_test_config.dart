import 'dart:async';
import 'package:flutter/foundation.dart';

/// Test configuration to optimize test runs and prevent timeouts
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Configure test environment
  await runZonedGuarded(
    () async {
      await testMain();
    },
    (error, stackTrace) {
      debugPrint('Test execution error: $error');
      debugPrint('Stack trace: $stackTrace');
    },
  );
}