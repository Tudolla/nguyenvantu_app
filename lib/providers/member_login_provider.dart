import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/auth_repository/auth_repository.dart';
import 'package:monstar/data/services/auth_service/auth_service.dart';
import 'package:monstar/views/login/login_viewmodel.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService);
});

final loginViewModelProvider =
    StateNotifierProvider<LoginViewmodel, AsyncValue<bool>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginViewmodel(authRepository);
});
