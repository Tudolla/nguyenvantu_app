import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/data/repository/api/book_repository/book_repository.dart';

class BookDetailViewmodel extends StateNotifier<AsyncValue<BookModel>> {
  final BookRepository bookRepository;

  BookDetailViewmodel({required this.bookRepository}) : super(AsyncLoading());

  Future<void> loadDetailBook(int id) async {
    try {
      final bookDetail = await bookRepository.getDetailBook(id);
      state = AsyncData(bookDetail);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
