import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/data/services/book_service/book_service.dart';

abstract class BookRepository {
  Future<List<BookModel>> getListBook();
}

class BookRepositoryIml implements BookRepository {
  final BookService _bookService;
  BookRepositoryIml(this._bookService);
  @override
  Future<List<BookModel>> getListBook() async {
    return await _bookService.fetchBookList();
  }
}
