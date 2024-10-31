import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/data/repository/api/book_repository/book_repository.dart';
import 'package:monstar/views/base/base_view_model.dart';

class BookDetailViewmodel extends BaseViewModel<BookModel?> {
  final BookRepository bookRepository;

  BookDetailViewmodel({required this.bookRepository}) : super(null);

  Future<void> loadDetailBook(int id) async {
    setLoadingWithPreviousData(); // Hiển thị dữ liệu cũ khi tải
    try {
      final bookDetail = await bookRepository.getDetailBook(id);
      setData(bookDetail);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }
}
