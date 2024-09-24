import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/api/request/book_model/book_model.dart';
import '../../../data/repository/api/book_repository/book_repository.dart';

class BookViewmodel extends StateNotifier<AsyncValue<List<BookModel>>> {
  int _currentPage = 1;
  bool _isFetchingMore = false;
  final BookRepository bookRepository;

  BookViewmodel({required this.bookRepository}) : super(AsyncLoading());

  Future<void> loadListBook() async {
    try {
      final result = await bookRepository.getListBook(page: _currentPage);
      final booksData = result['results'];
      if (booksData is List) {
        final books =
            booksData.map((data) => BookModel.fromJson(data)).toList();
        state = AsyncData(books);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> loadMoreBooks() async {
    if (_isFetchingMore) return; // Prevent multiple requests
    _isFetchingMore = true;

    try {
      _currentPage += 1;
      await bookRepository.getListBook(page: _currentPage);
      state.asData?.value ?? [];
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isFetchingMore = false;
    }
  }
}
