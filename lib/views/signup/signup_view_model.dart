import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/member_repository/member_repository.dart';

class SignupViewModel extends StateNotifier<LoginState> {
  final MemberRepository _memberRepository;
  String? errorMessage;

  SignupViewModel(this._memberRepository) : super(LoginState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);

    final result = await _memberRepository.login(username, password);
    if (result.contains("Welcome")) {
      state = state.copyWith(
        isLoading: true,
        message: "Chào mừng bạn đến với Monstarlab",
      );
    } else if (result.contains("Something went wrong. Try again")) {
      state = state.copyWith(
        isLoading: false,
        message: "Something went wrong. Try again",
      );
    } else if (result.contains("No Internet Connection")) {
      state = state.copyWith(
        isLoading: false,
        message: "No Internet Connection",
      );
    }
  }
}

class LoginState {
  final bool isLoading;
  final String? message;
  LoginState({
    this.isLoading = false,
    this.message,
  });

  LoginState copyWith({bool? isLoading, String? message}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}
