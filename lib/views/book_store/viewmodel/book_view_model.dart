import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/base/base_view_model.dart';

import '../../../data/models/api/request/book_model/book_model.dart';
import '../../../data/repository/api/book_repository/book_repository.dart';

class BookViewmodel extends BaseViewModel<List<BookModel>> {
  int _currentPage = 1;
  bool _isFetchingMore = false;
  final BookRepository bookRepository;

  BookViewmodel({required this.bookRepository}) : super([]);

  Future<void> loadListBook() async {
    setLoading();
    try {
      final result = await bookRepository.getListBook(page: _currentPage);

      if (result['results'] is List) {
        final booksData = ((result['results']) as List<dynamic>)
            .map((json) => BookModel.fromJson(json))
            .toList();

        setData(booksData);
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
    if (_isFetchingMore) return; // Prevent multiple requests
    _isFetchingMore = true;

    try {
      _currentPage += 1;
      final results = await bookRepository.getListBook(page: _currentPage);
      if (results['results'] is List) {
        final moreBooks = (results['results'] as List<dynamic>)
            .map((json) => BookModel.fromJson(json))
            .toList();
        final currentBooks = state.asData?.value ?? [];
        setData([...currentBooks, ...moreBooks]);
      } else {
        throw Exception("Exception error");
      }
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    } finally {
      _isFetchingMore = false;
    }
  }
}
