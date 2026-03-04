// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:mycoach/core/di/injection.dart' as _i692;
import 'package:mycoach/core/navigation/app_router.dart' as _i945;
import 'package:mycoach/core/network/api_client.dart' as _i607;
import 'package:mycoach/core/storage/secure_storage.dart' as _i301;
import 'package:mycoach/features/auth/data/datasources/auth_local_datasource.dart'
    as _i228;
import 'package:mycoach/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i584;
import 'package:mycoach/features/auth/data/repositories/auth_repository_impl.dart'
    as _i10;
import 'package:mycoach/features/auth/domain/repositories/auth_repository.dart'
    as _i975;
import 'package:mycoach/features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i137;
import 'package:mycoach/features/auth/domain/usecases/forgot_password_usecase.dart'
    as _i715;
import 'package:mycoach/features/auth/domain/usecases/login_usecase.dart'
    as _i762;
import 'package:mycoach/features/auth/domain/usecases/logout_usecase.dart'
    as _i187;
import 'package:mycoach/features/auth/domain/usecases/register_usecase.dart'
    as _i535;
import 'package:mycoach/features/auth/presentation/bloc/auth_bloc.dart'
    as _i409;
import 'package:mycoach/features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i558;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i945.AppRouter>(() => _i945.AppRouter());
    gh.factory<_i558.OnboardingBloc>(() => _i558.OnboardingBloc());
    gh.singleton<_i301.SecureStorage>(() => _i301.SecureStorage());
    gh.singleton<_i361.Dio>(() => registerModule.dio);
    gh.factory<_i584.AuthRemoteDataSource>(
        () => _i584.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.singleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
      instanceName: 'secureStorage',
    );
    gh.factory<_i228.AuthLocalDataSource>(() => _i228.AuthLocalDataSourceImpl(
          gh<_i558.FlutterSecureStorage>(instanceName: 'secureStorage'),
          gh<_i460.SharedPreferences>(),
        ));
    gh.singleton<_i607.ApiClient>(
        () => _i607.ApiClient(gh<_i301.SecureStorage>()));
    gh.factory<_i975.AuthRepository>(() => _i10.AuthRepositoryImpl(
          gh<_i584.AuthRemoteDataSource>(),
          gh<_i228.AuthLocalDataSource>(),
        ));
    gh.factory<_i137.CheckAuthStatusUseCase>(
        () => _i137.CheckAuthStatusUseCase(gh<_i975.AuthRepository>()));
    gh.factory<_i715.ForgotPasswordUseCase>(
        () => _i715.ForgotPasswordUseCase(gh<_i975.AuthRepository>()));
    gh.factory<_i762.LoginUseCase>(
        () => _i762.LoginUseCase(gh<_i975.AuthRepository>()));
    gh.factory<_i187.LogoutUseCase>(
        () => _i187.LogoutUseCase(gh<_i975.AuthRepository>()));
    gh.factory<_i535.RegisterUseCase>(
        () => _i535.RegisterUseCase(gh<_i975.AuthRepository>()));
    gh.factory<_i409.AuthBloc>(() => _i409.AuthBloc(
          gh<_i137.CheckAuthStatusUseCase>(),
          gh<_i762.LoginUseCase>(),
          gh<_i535.RegisterUseCase>(),
          gh<_i187.LogoutUseCase>(),
          gh<_i715.ForgotPasswordUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i692.RegisterModule {}
