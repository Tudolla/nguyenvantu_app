import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/base/base_view_model.dart';

import '../../../data/models/api/request/book_model/book_model.dart';
import '../../../data/repository/api/book_repository/book_repository.dart';

class BookViewmodel extends BaseViewModel<List<BookModel>> {
  int _currentPage = 1; // Refresh về trang đầu tiên
  bool _hasMoreData =
      true; // Kiểm tra dữ liệu có tiếp không khi người dùng load more
  bool _isFetchingMore = false;
  final BookRepository bookRepository;

  BookViewmodel({required this.bookRepository}) : super([]);

  Future<void> loadListBook() async {
    _currentPage = 1; // Reset về trang đầu khi tải lại
    _hasMoreData = true; // Có dữ liệu thì mới tải tiếp
    setLoading();
    try {
      final result = await bookRepository.getListBook(page: _currentPage);

      if (result['results'] is List) {
        final booksData = ((result['results']) as List<dynamic>)
            .map((json) => BookModel.fromJson(json))
            .toList();

        setData(booksData);

        // Kiểm tra còn dữ liệu không, để chuẩn bị cho hàm loadMoreBooks()
        _hasMoreData = result['next'] != null;
      } else {
        throw Exception(
          "Expected to be a list, got ${result['results'].runtimeType}",
        );
      }
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }

  Future<void> loadMoreBooks() async {
    if (_isFetchingMore || !_hasMoreData) return; // Prevent multiple requests
    _isFetchingMore = true;

    try {
      _currentPage += 1;
      final results = await bookRepository.getListBook(page: _currentPage);
      if (results['results'] is List) {
        final moreBooks = (results['results'] as List<dynamic>)
            .map((json) => BookModel.fromJson(json))
            .toList();
        final currentBooks = state.asData?.value ?? [];

        // expand List
        setData([...currentBooks, ...moreBooks]);

        // Cập nhật cờ 'hasMoteData'
        _hasMoreData = results['next'] != null;
      } else {
        throw Exception("Exception error");
      }
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    } finally {
      _isFetchingMore = false;
    }
  }

  // Cho phép các class khác kiểm tra ViewModel có đang tải thêm dữ liệu không
  bool get isLoadingMore => _isFetchingMore;
}
