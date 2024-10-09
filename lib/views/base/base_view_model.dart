import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseViewModel<T> extends StateNotifier<AsyncValue<T>> {
  BaseViewModel(T? firstState)
      : super(
          firstState != null ? AsyncData(firstState) : const AsyncLoading(),
        );

  // trang thai khi Loading
  void setLoading() {
    state = const AsyncValue.loading();
  }

  // trang thai khi co du lieu
  void setData(T data) {
    state = AsyncValue.data(data);
  }

  // trang thai loi

  void setError(Object e, StackTrace stackTrace) {
    state = AsyncValue.error(e, stackTrace);
  }
}
