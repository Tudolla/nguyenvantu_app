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
    const errorMessages = {
      NetworkException: "Network error",
      ServerException: "Server error",
      CacheException: "Cache error",
      ValidationException: "Validation error",
    };

    final errorMessage =
        errorMessages[e.runtimeType] ?? "An unexpected error occurred ";

    setError(errorMessage, stackTrace);
  }

  // Phương thức lấy dữ iệu mới, nhưng giữ nguyên trạng thái cũ
  // VD: hiển thị dữ liệu trên UI, User load làm mới, thì loading đè lên dữ liệu cũ đồng thời tải lại dữ liệu mới
  // Tăng trải nghiệm người dùng
  void setLoadingWithPreviousData() {
    if (state.hasValue) {
      state = AsyncValue<T>.loading().copyWithPrevious(state);
    } else {
      state = const AsyncValue.loading();
    }
  }
}
