import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/api/request/book_model/book_model.dart';
import '../../../data/repository/api/book_repository/book_repository.dart';

class BookViewmodel extends StateNotifier<AsyncValue<List<BookModel>>> {
  final BookRepository bookRepository;

  BookViewmodel({required this.bookRepository}) : super(AsyncLoading());

  Future<void> loadListBook() async {
    try {
      final listBook = await bookRepository.getListBook();
      state = AsyncData(listBook);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
