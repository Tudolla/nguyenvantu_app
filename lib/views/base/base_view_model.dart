import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../exceptions/app_exceptions.dart';

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

  // hàm xử lý lỗi chung, các lớp con có thể ghi đè nếu có lỗi cụ thể khác
  void handleError(AppException e, StackTrace stackTrace) {
    String errorMessage;
    if (e is NetworkException) {
      errorMessage = "Network error: ${e.message}";
    } else if (e is ServerException) {
      errorMessage = "Server error: ${e.message}";
    } else if (e is CacheException) {
      errorMessage = "Cache error: ${e.message}";
    } else if (e is ValidationException) {
      errorMessage = "Validation: ${e.message}";
    } else {
      errorMessage = "An unexpected error occurred: ${e.message}";
    }
    setError(errorMessage, stackTrace);
  }

  // PHương thức lấy duwxl iệu mới, nhưng giữ nguyên trạng thái cũ
  void setLoadingWithPreviousData() {
    state = AsyncValue<T>.loading().copyWithPrevious(state);
  }
}
