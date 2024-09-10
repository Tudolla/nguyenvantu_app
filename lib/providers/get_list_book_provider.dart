import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/data/repository/api/book_repository/book_repository.dart';
import 'package:monstar/data/services/book_service/book_service.dart';
import 'package:monstar/views/book_store/viewmodel/book_viewmodel.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final service = BookService();
  return BookRepositoryIml(service);
});

final bookListViewModelProvider =
    StateNotifierProvider<BookViewmodel, AsyncValue<List<BookModel>>>((ref) {
  final repository = ref.read(bookRepositoryProvider);
  return BookViewmodel(bookRepository: repository);
});
