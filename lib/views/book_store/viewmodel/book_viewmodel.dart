import 'dart:convert';

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

      if (result['results'] is List) {
        final booksData = ((result['results']) as List<dynamic>)
            .map((json) => BookModel.fromJson(json))
            .toList();
        state = AsyncData(booksData);
      } else {
        throw Exception(
          "Expected to be a list, got ${result['results'].runtimeType}",
        );
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
      final results = await bookRepository.getListBook(page: _currentPage);
      if (results['results'] is List) {
        final moreBooks = (results['results'] as List<dynamic>)
            .map((json) => BookModel.fromJson(json))
            .toList();
        final currentBooks = state.asData?.value ?? [];
        state = AsyncData([...currentBooks, ...moreBooks]);
      } else {
        throw Exception("VC");
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isFetchingMore = false;
    }
  }
}
