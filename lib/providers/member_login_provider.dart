import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/auth_repository/auth_repository.dart';
import 'package:monstar/data/services/auth_service/auth_service.dart';
import 'package:monstar/providers/http_client_provider.dart';
import 'package:monstar/views/login/login_view_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final httpClient = ref.read(httpClientProvider);

  return AuthService(httpClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthRepositoryImpl(authService);
});

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<bool?>>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginViewModel(authRepository);
});
