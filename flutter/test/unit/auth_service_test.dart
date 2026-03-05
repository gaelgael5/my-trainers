import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:mycoach/services/auth_service.dart';
import 'package:mycoach/services/api_service.dart';
import 'package:mycoach/services/storage_service.dart';
import 'package:mycoach/models/auth_request.dart';
import 'package:mycoach/models/api_response.dart';
import 'package:mycoach/models/user.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([ApiService, StorageService])
void main() {
  late AuthService authService;
  late MockApiService mockApiService;
  late MockStorageService mockStorageService;

  setUp(() {
    mockApiService = MockApiService();
    mockStorageService = MockStorageService();
    authService = AuthService(
      apiService: mockApiService,
      storageService: mockStorageService,
    );
  });

  group('AuthService', () {
    group('login', () {
      test('should return success when login is successful', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        
        final user = User(
          id: '1',
          email: email,
          firstName: 'John',
          lastName: 'Doe',
        );
        
        final loginResponse = LoginResponse(
          accessToken: 'access_token',
          refreshToken: 'refresh_token',
          user: user,
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );
        
        when(mockApiService.post<LoginResponse>(
          '/auth/login',
          body: any,
          fromJson: any,
        )).thenAnswer((_) async => ApiResponse.success(loginResponse));
        
        when(mockStorageService.saveAccessToken(any))
            .thenAnswer((_) async {});
        when(mockStorageService.saveRefreshToken(any))
            .thenAnswer((_) async {});
        when(mockStorageService.saveUser(any))
            .thenAnswer((_) async {});
        when(mockStorageService.saveTokenExpiry(any))
            .thenAnswer((_) async {});

        // Act
        final result = await authService.login(
          email: email,
          password: password,
        );

        // Assert
        expect(result.success, true);
        expect(result.data?.user.email, email);
        
        verify(mockStorageService.saveAccessToken('access_token'));
        verify(mockStorageService.saveRefreshToken('refresh_token'));
        verify(mockStorageService.saveUser(user));
      });

      test('should return error when login fails', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrong_password';
        
        when(mockApiService.post<LoginResponse>(
          '/auth/login',
          body: any,
          fromJson: any,
        )).thenAnswer((_) async => ApiResponse.error(
          'Email ou mot de passe incorrect',
          statusCode: 401,
        ));

        // Act
        final result = await authService.login(
          email: email,
          password: password,
        );

        // Assert
        expect(result.success, false);
        expect(result.error, 'Email ou mot de passe incorrect');
        
        verifyNever(mockStorageService.saveAccessToken(any));
        verifyNever(mockStorageService.saveUser(any));
      });
    });

    group('logout', () {
      test('should clear local data on logout', () async {
        // Arrange
        when(mockStorageService.getAccessToken())
            .thenAnswer((_) async => 'access_token');
        when(mockApiService.post('/auth/logout', token: any))
            .thenAnswer((_) async => ApiResponse.success(null));
        when(mockStorageService.clearAccessToken())
            .thenAnswer((_) async {});
        when(mockStorageService.clearRefreshToken())
            .thenAnswer((_) async {});
        when(mockStorageService.clearUser())
            .thenAnswer((_) async {});
        when(mockStorageService.clearTokenExpiry())
            .thenAnswer((_) async {});

        // Act
        final result = await authService.logout();

        // Assert
        expect(result.success, true);
        
        verify(mockStorageService.clearAccessToken());
        verify(mockStorageService.clearRefreshToken());
        verify(mockStorageService.clearUser());
        verify(mockStorageService.clearTokenExpiry());
      });
    });

    group('isLoggedIn', () {
      test('should return true when valid token exists', () async {
        // Arrange
        when(mockStorageService.getAccessToken())
            .thenAnswer((_) async => 'valid_token');
        when(mockStorageService.getTokenExpiry())
            .thenAnswer((_) async => DateTime.now().add(const Duration(hours: 1)));

        // Act
        final result = await authService.isLoggedIn();

        // Assert
        expect(result, true);
      });

      test('should return false when token is expired', () async {
        // Arrange
        when(mockStorageService.getAccessToken())
            .thenAnswer((_) async => 'expired_token');
        when(mockStorageService.getTokenExpiry())
            .thenAnswer((_) async => DateTime.now().subtract(const Duration(hours: 1)));
        when(mockStorageService.getRefreshToken())
            .thenAnswer((_) async => null);

        // Act
        final result = await authService.isLoggedIn();

        // Assert
        expect(result, false);
      });

      test('should return false when no token exists', () async {
        // Arrange
        when(mockStorageService.getAccessToken())
            .thenAnswer((_) async => null);
        when(mockStorageService.getTokenExpiry())
            .thenAnswer((_) async => null);

        // Act
        final result = await authService.isLoggedIn();

        // Assert
        expect(result, false);
      });
    });

    group('forgotPassword', () {
      test('should return success when email is valid', () async {
        // Arrange
        const email = 'test@example.com';
        
        when(mockApiService.post<void>(
          '/auth/forgot-password',
          body: any,
        )).thenAnswer((_) async => ApiResponse.success(null));

        // Act
        final result = await authService.forgotPassword(email);

        // Assert
        expect(result.success, true);
      });

      test('should return error when email is invalid', () async {
        // Arrange
        const email = 'invalid@example.com';
        
        when(mockApiService.post<void>(
          '/auth/forgot-password',
          body: any,
        )).thenAnswer((_) async => ApiResponse.error(
          'Email non trouvé',
          statusCode: 404,
        ));

        // Act
        final result = await authService.forgotPassword(email);

        // Assert
        expect(result.success, false);
        expect(result.error, 'Email non trouvé');
      });
    });
  });
}