import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fonction d'aide pour initialiser l'environnement de test
void initializeTestEnvironment() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Mock les canaux de méthode système
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/shared_preferences'),
    (MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{};
      }
      return null;
    },
  );
  
  // Mock pour flutter_secure_storage
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
    (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'read':
        case 'readAll':
          return null;
        case 'write':
        case 'delete':
        case 'deleteAll':
          return null;
        case 'containsKey':
          return false;
        default:
          return null;
      }
    },
  );
}