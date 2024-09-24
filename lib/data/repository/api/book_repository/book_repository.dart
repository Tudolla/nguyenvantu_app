import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/data/services/book_service/book_service.dart';

abstract class BookRepository {
  Future<Map<String, dynamic>> getListBook({int page = 1});
  Future<BookModel> getDetailBook(int id);
}

class BookRepositoryIml implements BookRepository {
  final BookService _bookService;
  BookRepositoryIml(this._bookService);
  @override
  Future<Map<String, dynamic>> getListBook({int page = 1}) async {
    return await _bookService.fetchBookList(page: page);
  }

  @override
  Future<BookModel> getDetailBook(int id) async {
    return await _bookService.fetchBookDetail(id);
  }
}
