import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../../../shared/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  AuthBloc(
    this._checkAuthStatusUseCase,
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._forgotPasswordUseCase,
  ) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthForgotPasswordRequested>(_onAuthForgotPasswordRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      final user = await _checkAuthStatusUseCase();
      
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
        clearUser: true,
      ));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    
    try {
      final authResponse = await _loginUseCase(
        email: event.email,
        password: event.password,
      );
      
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.user,
        successMessage: 'Connexion réussie',
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e.toString()),
        clearUser: true,
      ));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    
    try {
      await _registerUseCase(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        role: event.role,
        phone: event.phone,
      );
      
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        successMessage: 'Compte créé avec succès. Veuillez vous connecter.',
        clearError: true,
        clearUser: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e.toString()),
        clearUser: true,
      ));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      await _logoutUseCase();
      
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
        successMessage: 'Déconnexion réussie',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e.toString()),
      ));
    }
  }

  Future<void> _onAuthForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    
    try {
      await _forgotPasswordUseCase(email: event.email);
      
      emit(state.copyWith(
        status: state.isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        successMessage: 'Email de réinitialisation envoyé',
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: state.isAuthenticated ? AuthStatus.authenticated : AuthStatus.error,
        errorMessage: _formatErrorMessage(e.toString()),
      ));
    }
  }

  void _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      status: AuthStatus.authenticated,
      user: event.user,
    ));
  }

  String _formatErrorMessage(String error) {
    // Format common API error messages to French
    if (error.toLowerCase().contains('invalid credentials')) {
      return 'Identifiants invalides';
    } else if (error.toLowerCase().contains('user already exists')) {
      return 'Un compte avec cet email existe déjà';
    } else if (error.toLowerCase().contains('network')) {
      return 'Erreur de connexion. Vérifiez votre internet.';
    } else if (error.toLowerCase().contains('server')) {
      return 'Erreur serveur. Veuillez réessayer plus tard.';
    }
    
    return error.isNotEmpty ? error : 'Une erreur inattendue s\'est produite';
  }
}