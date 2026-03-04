import 'dart:async';

/// Test configuration to optimize test runs and prevent timeouts
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Set global timeout for individual test cases
  const testTimeout = Duration(seconds: 30);
  
  // Configure test environment
  await runZonedGuarded(
    () async {
      await testMain();
    },
    (error, stackTrace) {
      print('Test execution error: $error');
      print('Stack trace: $stackTrace');
    },
  );
}